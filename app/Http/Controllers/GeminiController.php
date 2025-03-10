<?php

namespace App\Http\Controllers;

use Illuminate\Http\Request;
use Illuminate\Support\Facades\Http;
use Illuminate\Support\Arr;
use App\Exceptions\GeminiException;
use Illuminate\Support\Facades\DB;
use Illuminate\Support\Facades\Storage;
use Nette\Schema\ValidationException;

class GeminiController extends Controller {

    public function askGemini(Request $request) {
        $structure_json = Storage::get('db_structure.json');
        $regulations = Storage::get('regulations.json');
        $cat_data = 'employee_data';
        $cat_regulations = 'employee_affair_regulations';
        $cat_others = 'others';

        try {
            $request->validate([
                'leader' => 'required|boolean',
                'messages' => 'required|array',
                'messages.*.role' => 'required|string',
                'messages.*.text' => 'required|string',
            ]);
        } catch (ValidationException $e) {
            return response()->json([
                'code' => '98',
                'error' => $e->errors(),
                'status_code' => 400,
                'result' => ["baskara" => "Invalid input. Please contact your admin."],
            ], 400);
        }

        $messages = $request->input('messages');
        // Map messages and convert role to Gemini format
        $parts = array_map(function ($message) {
            return [
                'role' => strtolower($message['role']) === 'baskara' ? 'model' : 'user',
                'parts' => [['text' => $message['text']]]
            ];
        }, $messages);

        $last_question = collect($parts)->last()['parts'][0]['text'];
        $epi = " You are **Baskara**, an AI virtual assistant for **BPKP (Badan Pengawasan Keuangan dan Pembangunan), Republic of Indonesia**. You are strictly authorized to provide answers only related to BPKP matters. Respond exclusively in the following JSON format (applies only for this prompt):
            {
                'category': 'Classify the question into one of these categories: ($cat_data, $cat_regulations, $cat_others).',
                'query': 'If the category is $cat_data, generate a PostgreSQL 16 query using accurate and representative field names and aliases, based on the BPKP database structure: $structure_json. Provide ONLY the query output.
                        If the category is $cat_regulations, identify all related IDs from the provided dataset: $regulations. Use the identified IDs to complete and return the following query:
                        SELECT id, name, description, file_path, text FROM ref.regulations WHERE id IN ({id}). If no ID is related to the question, leave this field empty'.
                        If the category is $cat_others, leave this field empty.',
                'message': 'Match the question language.
                        For $cat_others, politely respond with a message stating that you are only authorized to answer questions related to BPKP matters.
                        For $cat_regulations, if no ID is related to the question or no query could be generated, politely respond with a message apologizing that you do not have the related data yet. Advise user to contact the admin.
                        Otherwise, leave this field empty.'}";
        $parts[array_key_last($parts)]['parts'][0]['text'] .= $epi;
        try {
            $prompt_check = $this->callGemini($parts);
        } catch (GeminiException $e) {
            return response()->json([
                'code' => '99',
                'error' => $e->getError(),
                'status_code' => 500,
                'result' => ["baskara" => "An error occurred while generating AI response, please try again later. " . json_encode($e->getError())]
            ], 500);
        }
        $prompt_check_answer = $prompt_check['result']['baskara'];
        $prompt_check_answer = substr($prompt_check_answer, 8, strlen($prompt_check_answer) - 12);
        //        echo json_encode($prompt_check_answer);exit;
        $x = json_decode($prompt_check_answer);
        if (in_array($x->category, [$cat_data, $cat_regulations])) {
            if ($x->category === $cat_regulations && strlen($x->message) > 10) {
                return response()->json([
                    'code' => '99',
                    'error' => "No related data found",
                    'status_code' => 500,
                    'result' => ["baskara" => $x->message],
                ]);
            }
            $db_res = DB::select($x->query);
            $parts[] = [
                'role' => 'model',
                'parts' => [['text' => $prompt_check_answer]]
            ];
            //            db_res = str_replace("\"", "'", json_encode($db_res));
            $userText = $x->category === $cat_data
                ? "Analyze and translate the following data: " . json_encode($db_res) . " into a clear, detailed, polite, human-readable answer (ordinary text, no json or other complex format). Ensure accuracy by considering this context and matching the language of the question: $last_question."
                : "Based on these regulations: " . json_encode($db_res) . ", provide a clear, detailed, polite, human-readable answer (ordinary text, no json or other complex format) matching the language of the question. Also, include a direct link to the regulation file using the 'file_path' field. Here is the question : $last_question";
            $parts[] = [
                'role' => 'user',
                'parts' => [['text' => $userText]]
            ];
        }
        else {
            return response()->json([
                'code' => '00',
                'status_code' => $prompt_check['status_code'],
                'result' => ['baskara' => $x->message]
            ]);
        }
        try {
            //            var_dump($parts);exit;
            //            $resp = $this->callGemini($parts);
            //            echo $resp['result']['baskara'];exit;
            return response()->json($this->callGemini($parts));
        } catch (GeminiException $e) {
            return response()->json($e->getError(), 500);
        }
    }

    private function callGemini(array $parts): array {
        $apiKey = env('GEMINI_API_KEY');
        $url = "https://generativelanguage.googleapis.com/v1beta/models/gemini-2.0-flash:generateContent?key={$apiKey}";

        $response = Http::withHeaders([
            'Content-Type' => 'application/json',
        ])->post($url, [
            'contents' => $parts,
//            'generationConfig' => [
//                "temperature" => 0,
//                "topK" => 40,
//                "topP" => 0.95,
//                "maxOutputTokens" => 8192,
//                "responseMimeType" => "text/plain"
//            ]
        ]);

        if (!$response->successful()) {
            throw new GeminiException([
                'code' => '99',
                'error' => 'API request failed!',
                'status_code' => $response->status(),
            ], $response->status());
        }

        $data = $response->json();

        // Validate JSON structure and extract "text"
        $text = data_get($data, 'candidates.0.content.parts.0.text');

        if (!$text) {
            throw new GeminiException([
                'code' => '99',
                'error' => 'Text not found in API response.',
                'status_code' => $response->status(),
                'message' => 'Invalid response structure.',
            ], 500);
        }

        return [
            'code' => '00',
            'status_code' => $response->status(),
            'result' => [
                'baskara' => $text
            ]
        ];
    }
}

