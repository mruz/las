<?php

namespace Las\Extension;

/**
 * Dns Validator
 *
 * @package     las
 * @category    Extension
 * @version     1.0
 */
class Dns extends \Phalcon\Validation\Validator implements \Phalcon\Validation\ValidatorInterface
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

        $addresses = explode(',', $value);
        $label = $this->getOption("label");

        if (empty($label)) {
            $label = $validation->getLabel($field);

            if (empty($label)) {
                $label = $field;
            }
        }

        if (!in_array(count($addresses), range(1, 3))) {
            $message = $validation->getDefaultMessage("Between");
            $replacePairs = array(":field" => $label, ":min" => 1, ":max" => 3);
            $validation->appendMessage(new \Phalcon\Validation\Message(strtr($message, $replacePairs), $field, "Between"));
            return false;
        }

        foreach ($addresses as $address) {
            // Check each address
            if (!filter_var(trim($address), FILTER_VALIDATE_IP, FILTER_FLAG_IPV4 | FILTER_FLAG_IPV6)) {
                $message = $this->getOption("message");
                $replacePairs = array(":field" => $label);

                if (empty($message)) {
                    $message = $validation->getDefaultMessage("Dns");
                }

                $validation->appendMessage(new \Phalcon\Validation\Message(strtr($message, $replacePairs), $field, "Dns"));
                return false;
            }
        }
        return true;
    }

}
