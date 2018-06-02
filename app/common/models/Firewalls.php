<?php

namespace Las\Models;

use Las\Extension;
use Phalcon\Validation\Validator;

/**
 * Firewalls Model
 *
 * @package     las
 * @category    Model
 * @version     1.0
 */
class Firewalls extends \Phalcon\Mvc\Model
{

    const UNACTIVE = 0;
    const ACTIVE = 1;
    const RELOAD = 2;
    const COMPILE = 3;
    const COMPILED = 4;

    private $request;

    /**
     * Initialize firewall
     *
     * @package     las
     * @version     1.0
     */
    public function onConstruct()
    {
        $this->request = $this->getDI()->getShared('request');
    }

    /**
     * Get firewall's status(es)
     *
     * @package     las
     * @version     1.0
     *
     * @param mixed $key key to get status
     * @param string $type type of data
     * @return mixed
     */
    public static function status($key = false, $type = 'text')
    {
        $status = [
            Firewalls::UNACTIVE => ['text' => __('Unactive'), 'color' => 'text-muted'],
            Firewalls::ACTIVE => ['text' => __('Active'), 'color' => 'text-danger'],
            Firewalls::RELOAD => ['text' => __('Reload'), 'color' => 'text-info'],
            Firewalls::COMPILE => ['text' => __('Compile'), 'color' => 'text-warning'],
            Firewalls::COMPILED => ['text' => __('Compiled'), 'color' => 'text-success'],
        ];
        if ($key !== false) {
            if ($key !== true) {
                return $status[$key][$type];
            } else {
                $array = [];

                foreach ($status as $key => $value) {
                    $array [$key] = $value[$type];
                }
                return $array;
            }
        } else {
            return array_keys($status);
        }
    }

    /**
     * Write method - add/edit the firewall
     *
     * @package     las
     * @version     1.0
     *
     * @param string $method type of method: create/update
     * @return mixed
     */
    public function write($method = 'create')
    {
        $validation = new Extension\Validation();

        $validation->add('name', new Validator\PresenceOf());
        $validation->add('name', new Validator\StringLength([
            'max' => 32,
        ]));
        $validation->add('content', new Validator\PresenceOf());
        $validation->add('description', new Validator\StringLength([
            'max' => 1024,
        ]));
        $validation->add('status', new Validator\InclusionIn([
            'domain' => Firewalls::status()
        ]));

        $validation->setLabels([
            'name' => __('Name'),
            'content' => __('Content'),
            'description' => __('Description'),
            'status' => __('Status'),
        ]);
        $messages = $validation->validate($_POST);

        // Return messages if validation not pass
        if (count($messages)) {
            return $validation->getMessages();
        } else {
            $this->name = $this->request->getPost('name', 'string');
            $this->content = $this->request->getPost('content');
            $this->description = $this->request->getPost('description', 'string');
            $this->status = $this->request->getPost('status', 'int');
            $this->date = date('Y-m-d H:i:s');

            // Try to write the record
            if ($this->$method() === true) {
                return $this;
            } else {
                \Las\Bootstrap::log($this->getMessages());
                return $this->getMessages();
            }
        }
    }

}
