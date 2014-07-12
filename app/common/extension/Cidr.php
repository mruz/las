<?php

namespace Las\Extension;

/**
 * Cidr Validator
 *
 * @package     las
 * @category    Extension
 * @version     1.0
 */
class Cidr extends \Phalcon\Validation\Validator implements \Phalcon\Validation\ValidatorInterface
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

        $cidr = $this->getOption("cidr");
        list($subnet, $mask) = explode('/', $cidr);

        if (($value & ~((1 << (32 - $mask)) - 1) ) != $subnet) {
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
                $message = $validation->getDefaultMessage("Cidr");
                if (empty($message)) {
                    $message = 'Field :field must match to the subnetwork';
                    $validation->setDefaultMessages(['Cidr' => $message]);
                }
            }

            $validation->appendMessage(new \Phalcon\Validation\Message(strtr($message, $replacePairs), $field, "Cidr"));
            return false;
        }
        return true;
    }

}
