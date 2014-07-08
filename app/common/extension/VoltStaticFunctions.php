<?php

namespace Las\Extension;

/**
 * Static functions in Volt
 *
 * @package     las
 * @category    Library
 * @version     1.0
 */
class VoltStaticFunctions
{

    /**
     * Compile static function call in a template
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
        if (strpos($name, '__')) {
            // Get property
            $property = substr(strstr($name, '__'), 2);
            // Prepare namespace; replace _\ to \, make first characters uppercase
            $namespace = '\\' . implode('\\', array_map('ucfirst', preg_split('/(\\\\|_)/', strstr($name, '__', true))));

            // Allow to use short syntax for library and models
            foreach (array('\Las', '\Las\Library', '\Las\Models', '') as $prefix) {
                $class = $prefix . $namespace;
                if (method_exists($class, $property)) {
                    return $class . '::' . $property . '(' . $arguments . ')';
                }

                if (!$arguments) {
                    // Get constant if exist
                    if (defined($class . '::' . $property)) {
                        return $class . '::' . $property;
                    }

                    // Get static property if exist
                    if (property_exists($class, $property)) {
                        return $class . '::$' . $property;
                    }
                }
            }
        }
    }

    /**
     * Compile label filter
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
        if ($name == 'label') {
            return '\Las\Library\Tool::label(' . $arguments . ')';
        }
    }

}
