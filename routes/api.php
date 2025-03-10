<?php

use App\Http\Controllers\GeminiDevController;
use Illuminate\Support\Facades\Route;
use App\Http\Controllers\GeminiController;

Route::get('/most-expensive-product', [GeminiController::class, 'getMostExpensiveProduct']);
Route::post('/ask-baskara', [GeminiController::class, 'askGemini']);
Route::post('/ask-baskara-dev', [GeminiDevController::class, 'askGemini']);
