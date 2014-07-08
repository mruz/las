<?php

/**
 * index.php
 *
 * @package     las
 * @version     1.0
 */
error_reporting(E_ALL);
try {
    // Global translation function
    if (!function_exists('__')) {

        /**
         * Translate message
         *
         * @package     las
         * @version     1.0
         *
         * @param string $string string to translate
         * @param array $values replace substrings
         *
         * @return string translated string
         */
        function __($string, array $values = NULL)
        {
            return \Las\Library\I18n::instance()->_($string, $values);
        }

    }

    if (!defined('ROOT_PATH')) {
        define('ROOT_PATH', dirname(__DIR__));
    }

    require_once ROOT_PATH . '/app/Bootstrap.php';

    $app = new \Las\Bootstrap(new \Phalcon\DI\FactoryDefault());
    echo $app->handle()->getContent();
} catch (\Phalcon\Exception $e) {
    \Las\Bootstrap::exception($e);
} catch (\PDOException $e) {
    \Las\Bootstrap::exception($e);
} catch (\Exception $e) {
    \Las\Bootstrap::exception($e);
}