<?php

namespace Las\Extension;

/**
 * Together Validator
 *
 * @package     las
 * @category    Extension
 * @version     1.0
 */
class Together extends \Phalcon\Validation\Validator implements \Phalcon\Validation\ValidatorInterface
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

        if ($this->hasOption("allowEmpty") && empty($value)) {
            return true;
        }

        $label = $this->getOption("label");

        if (empty($label)) {
            $label = $validation->getLabel($field);

            if (empty($label)) {
                $label = $field;
            }
        }


        if ($and = $this->getOption("with")) {
            $message = $this->getOption("message");
            if (empty($message)) {
                $message = $validation->getDefaultMessage("TogetherWith");
                if (empty($message)) {
                    $message = 'Field :field must occur together with :with';
                }
            }

            $empty = [];
            foreach ($and as $key => $with) {
                if (is_string($key)) {
                    $with = is_array($with) ? $with : array($with);
                    if (!in_array($validation->getValue($key), $with)) {
                        $empty[] = $validation->getLabel($key) . ' (' . join(', ', $with) . ')';
                    }
                } else {
                    if (!$validation->getValue($with)) {
                        $empty[] = $validation->getLabel($with);
                    }
                }
            }
            if (count($empty)) {
                $replacePairs = array(":field" => $label, ":with" => join(', ', $empty));
                $validation->appendMessage(new \Phalcon\Validation\Message(strtr($message, $replacePairs), $field, "TogetherWith"));
//                return false;
            }
        }

        if ($or = $this->getOption("withOr")) {
            $messageWithOr = $this->getOption("messageWithOr");
            if (empty($messageWithOr)) {
                $messageWithOr = $validation->getDefaultMessage("TogetherWithOr");
                if (empty($messageWithOr)) {
                    $messageWithOr = 'Field :field must occur together with one of: :with';
                }
            }
            $empty = [];
            foreach ($or as $key => $with) {
                if (is_string($key)) {
                    $with = is_array($with) ? $with : array($with);
                    if (in_array($validation->getValue($key), $with)) {
                        $empty[] = $validation->getLabel($key) . ' (' . join(', ', $with) . ')';
                    }
                } else {
                    if ($validation->getValue($with)) {
                        $empty[] = $validation->getLabel($with);
                    }
                }
            }
            if (!count($empty)) {
                $replacePairs = array(":field" => $label, ":with" => join(', ', $or));
                $validation->appendMessage(new \Phalcon\Validation\Message(strtr($messageWithOr, $replacePairs), $field, "TogetherWithOr"));
//                return false;
            }
        }

        if ($out = $this->getOption("without")) {
            $messageWithout = $this->getOption("messageWithout");
            if (empty($messageWithout)) {
                $messageWithout = $validation->getDefaultMessage("TogetherWithout");
                if (empty($messageWithout)) {
                    $messageWithout = 'Field :field must not occur together with :with';
                }
            }

            $empty = [];
            foreach ($out as $key => $with) {
                if (is_string($key)) {
                    $with = is_array($with) ? $with : array($with);
                    if (in_array($validation->getValue($key), $with)) {
                        $empty[] = $validation->getLabel($key) . ' (' . join(', ', $with) . ')';
                    }
                } else {
                    if ($validation->getValue($with)) {
                        $empty[] = $validation->getLabel($with);
                    }
                }
            }
            if (count($empty)) {
                $replacePairs = array(":field" => $label, ":with" => join(', ', $empty));
                $validation->appendMessage(new \Phalcon\Validation\Message(strtr($messageWithout, $replacePairs), $field, "TogetherWithout"));
//                return false;
            }
        }
//        return true;
    }

}
