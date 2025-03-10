<?php

namespace App\Exceptions;

use Exception;

class GeminiException extends Exception
{
    public $error;

    public function __construct($error, $code = 400)
    {
        $this->error = $error;
        parent::__construct(json_encode($error), $code);
    }

    public function getError()
    {
        return $this->error;
    }
}
