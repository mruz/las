<?php

namespace Las\Models;

use Las\Library\Arr;
use Phalcon\Validation\Validator;

/**
 * Clients Model
 *
 * @package     las
 * @category    Model
 * @version     1.0
 */
class Clients extends \Phalcon\Mvc\Model
{

    const UNACTIVE = 0;
    const ACTIVE = 1;
    const INDEBTED = 2;
    const DISCONNECTED = 3;

    private $request;
    private $tariffs;

    /**
     * Initialize client
     *
     * @package     las
     * @version     1.0
     */
    public function onConstruct()
    {
        $this->belongsTo('tariff_id', __NAMESPACE__ . '\Tariffs', 'id', [
            'alias' => 'Tariff'
        ]);
        $this->hasMany('id', __NAMESPACE__ . '\Devices', 'client_id', [
            'alias' => 'Devices'
        ]);
        $this->hasMany('id', __NAMESPACE__ . '\Messages', 'client_id', [
            'alias' => 'ClientMessages'
        ]);
        $this->hasMany('id', __NAMESPACE__ . '\Payments', 'client_id', [
            'alias' => 'Payments'
        ]);
        $this->hasMany('id', __NAMESPACE__ . '\Services', 'client_id', [
            'alias' => 'Services'
        ]);

        $this->request = $this->getDI()->getShared('request');
    }

    /**
     * Get client's status(es)
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
            Clients::UNACTIVE => ['text' => __('Unactive'), 'color' => 'text-muted'],
            Clients::ACTIVE => ['text' => __('Active'), 'color' => 'text-success'],
            Clients::INDEBTED => ['text' => __('Indebted'), 'color' => 'text-warning'],
            Clients::DISCONNECTED => ['text' => __('Disconnected'), 'color' => 'text-danger'],
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
     * Write method - add/edit the client
     *
     * @package     las
     * @version     1.0
     *
     * @param string $method type: create/update
     * @return mixed
     */
    public function write($method = 'create')
    {
        $validation = new \Las\Extension\Validation();

        $validation->add('fullName', new Validator\PresenceOf());
        $validation->add('fullName', new Validator\StringLength([
            'min' => 3,
            'max' => 32,
        ]));
        $validation->add('address', new Validator\StringLength([
            'max' => 256,
        ]));
        $validation->add('tariff', new Validator\PresenceOf());
        $validation->add('tariff', new Validator\InclusionIn([
            'domain' => Arr::from_model($this->tariffs, NULL, 'id'),
        ]));
        $validation->add('description', new Validator\StringLength([
            'max' => 1024,
        ]));
        $validation->add('status', new Validator\InclusionIn([
            'domain' => Clients::status()
        ]));

        $validation->setLabels([
            'fullName' => __('Full name'),
            'address' => __('Address'),
            'tariff' => __('Tariff'),
            'description' => __('Description'),
            'status' => __('Status'),
        ]);
        $messages = $validation->validate($_POST);

        // Return messages if validation not pass
        if (count($messages)) {
            return $validation->getMessages();
        } else {
            $this->fullName = $this->request->getPost('fullName', 'string');
            $this->address = $this->request->getPost('address', 'string');
            $this->tariff_id = $this->request->getPost('tariff', 'int');
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
