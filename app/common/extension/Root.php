<?php

namespace Las\Extension;

/**
 * Root Validator
 *
 * @package     las
 * @category    Extension
 * @version     1.0
 */
class Root extends \Phalcon\Validation\Validator implements \Phalcon\Validation\ValidatorInterface
{

    /**
     * Executes the validation
     *
     * @package     las
     * @version     1.0
     *
     * @param object $validation Phalcon\Validation
     * @param string $field field name
     *
     * @return boolean
     */
    public function validate($validation, $field)
    {
        $value = $validation->getValue($field);

        if ($this->isSetOption("allowEmpty") && empty($value)) {
            return true;
        }

        exec('echo ' . $value . ' | su -c whoami', $results);

        if (!isset($results[0]) || $results[0] != 'root') {
            $label = $this->getOption("label");

            if (empty($label)) {
                $label = $validation->getLabel($field);
            }

            $message = $this->getOption("message");
            $replacePairs = array(":field" => $label);

            if (empty($message)) {
                $message = $validation->getDefaultMessage("Root");

                if (empty($message)) {
                    $message = 'Authorization failure';
                }
            }

            $validation->appendMessage(new \Phalcon\Validation\Message(strtr($message, $replacePairs), $field, "Root"));
            return false;
        }
        return true;
    }

}
