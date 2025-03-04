<?php

use Illuminate\Support\Facades\Route;
use App\Http\Controllers\GeminiController;

Route::get('/most-expensive-product', [GeminiController::class, 'getMostExpensiveProduct']);
