<?php

namespace Las\Extension;

/**
 * Escape filter - convert characters to HTML entities
 *
 * @package     las
 * @category    Extension
 * @version     1.0
 */
class Escape
{

    /**
     * Add the new filter
     *
     * @package     las
     * @version     1.0
     *
     * @param string $string string to filtering
     *
     * @return string filtered string
     */
    public function filter($string)
    {
        return htmlspecialchars((string) $string, ENT_QUOTES);
    }

}
