#!/usr/bin/php
<?php
/**
 * index.php for CLI
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
    require_once ROOT_PATH . '/app/Console.php';

    $console = new \Las\Console(new \Phalcon\DI\FactoryDefault\CLI());
    $console->handle($argv);
} catch (\Phalcon\Exception $e) {
    \Las\Console::exception($e);
} catch (\PDOException $e) {
    \Las\Console::exception($e);
} catch (\Exception $e) {
    \Las\Console::exception($e);
}