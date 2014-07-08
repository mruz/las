<?php

namespace Las\Extension;

/**
 * PHP Functions in Volt
 *
 * @package     las
 * @category    Library
 * @version     1.0
 */
class VoltPHPFunctions
{

    /**
     * Compile any function call in a template
     *
     * @package     las
     * @version     1.0
     *
     * @param string $name function name
     * @param mixed $arguments function args
     *
     * @return string compiled function
     */
    public function compileFunction($name, $arguments)
    {
        if (function_exists($name)) {
            return $name . '(' . $arguments . ')';
        }

        if ($name == 'dump') {
            return '\Phalcon\Debug\Dump::all(' . $arguments . ')';
        }
    }

    /**
     * Compile some filters
     *
     * @package     las
     * @version     1.0
     *
     * @param string $name filter name
     * @param mixed $arguments filter args
     *
     * @return string compiled filter
     */
    public function compileFilter($name, $arguments)
    {
        if ($name == 'isset') {
            return '(isset(' . $arguments . ') ? ' . $arguments . ' : null)';
        }
        if ($name == 'long2ip') {
            return 'long2ip(' . $arguments . ')';
        }
    }

}
