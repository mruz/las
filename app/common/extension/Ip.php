<?php

namespace Las\Extension;

/**
 * Ip Validator
 *
 * @package     las
 * @category    Extension
 * @version     1.0
 */
class Ip extends \Phalcon\Validation\Validator implements \Phalcon\Validation\ValidatorInterface
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


        if ($this->isSetOption("value")) {
            $value = $this->getOption("value");
        }

        if ($this->isSetOption("allowEmpty") && empty($value)) {
            return true;
        }

        if (!filter_var($value, FILTER_VALIDATE_IP, FILTER_FLAG_IPV4 | FILTER_FLAG_IPV6)) {
            $label = $this->getOption("label");

            if (empty($label)) {
                $label = $validation->getLabel($field);

                if (empty($label)) {
                    $label = $field;
                }
            }

            $message = $this->getOption("message");
            $replacePairs = array(":field" => $label);

            if (empty($message)) {
                $message = $validation->getDefaultMessage("Ip");
                if (empty($message)) {
                    $message = 'Field :field must be ip';
                }
            }

            $validation->appendMessage(new \Phalcon\Validation\Message(strtr($message, $replacePairs), $field, "Ip"));
            return false;
        }
        return true;
    }

}
