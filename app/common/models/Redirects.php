<?php

namespace Las\Models;

use Las\Extension;
use Las\Library\Arr;
use Phalcon\Validation\Validator;

/**
 * Redirects Model
 *
 * @package     las
 * @category    Model
 * @version     1.0
 */
class Redirects extends \Phalcon\Mvc\Model
{

    const UNACTIVE = 0;
    const ACTIVE = 1;
    const TCP = 1;
    const UDP = 2;

    private $devices;
    private $request;

    /**
     * Initialize redirect
     *
     * @package     las
     * @version     1.0
     */
    public function onConstruct()
    {
        $this->belongsTo('device_id', __NAMESPACE__ . '\Devices', 'id', [
            'alias' => 'Device'
        ]);

        $this->request = $this->getDI()->getShared('request');
    }

    /**
     * Get redirect's status(es)
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
            Redirects::UNACTIVE => ['text' => __('Unactive'), 'color' => 'text-muted'],
            Redirects::ACTIVE => ['text' => __('Active'), 'color' => 'text-success'],
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
     * Get redirect's type(s)
     *
     * @package     las
     * @version     1.0
     *
     * @param mixed $key key to get type
     * @return mixed
     */
    public static function type($key = false)
    {
        $type = [
            Redirects::TCP => __('TCP'),
            Redirects::UDP => __('UDP'),
        ];
        if ($key !== false) {
            return $key === true ? $type : $type[$key];
        } else {
            return array_keys($type);
        }
    }

    /**
     * Write method - add/edit the redirect
     *
     * @package     las
     * @version     1.0
     *
     * @param string $method type: create/update
     * @return mixed
     */
    public function write($method = 'create')
    {
        $validation = new Extension\Validation();

        $validation->add('name', new Validator\PresenceOf());
        $validation->add('name', new Validator\StringLength([
            'min' => 3,
            'max' => 32,
        ]));
        $validation->add('device', new Validator\PresenceOf());
        $validation->add('device', new Validator\InclusionIn([
            'domain' => Arr::from_model($this->devices, null, 'id'),
        ]));
        $validation->add('type', new Validator\InclusionIn([
            'domain' => Redirects::type()
        ]));
        $validation->add('externalStartingPort', new Validator\Between([
            'minimum' => 1,
            'maximum' => 65535,
        ]));
        $validation->add('externalEndingPort', new Validator\Between([
            'minimum' => 1,
            'maximum' => 65535,
            'allowEmpty' => true
        ]));
        $validation->add('internalStartingPort', new Validator\Between([
            'minimum' => 1,
            'maximum' => 65535,
            'allowEmpty' => true
        ]));
        $validation->add('internalEndingPort', new Validator\Between([
            'minimum' => 1,
            'maximum' => 65535,
            'allowEmpty' => true
        ]));
        $validation->add('description', new Validator\StringLength([
            'max' => 1024,
        ]));
        $validation->add('status', new Validator\InclusionIn([
            'domain' => Redirects::status()
        ]));

        $validation->setLabels([
            'name' => __('Name'),
            'device' => __('Device'),
            'type' => __('Type'),
            'externalStartingPort' => __('External starting port'),
            'externalEndingPort' => __('External ending port'),
            'internalStartingPort' => __('Internal starting port'),
            'internalEndingPort' => __('Internal ending port'),
            'description' => __('Description'),
            'status' => __('Status'),
        ]);
        $messages = $validation->validate($_POST);

        // Return messages if validation not pass
        if (count($messages)) {
            return $validation->getMessages();
        } else {
            $this->name = $this->request->getPost('name', 'string');
            $this->device_id = $this->request->getPost('device', 'int');
            $this->type = $this->request->getPost('type', 'int');
            $this->externalStartingPort = $this->request->getPost('externalStartingPort', 'int');
            $this->externalEndingPort = $this->request->getPost('externalEndingPort', 'int', null, true);
            $this->internalStartingPort = $this->request->getPost('internalStartingPort', 'int', null, true);
            $this->internalEndingPort = $this->request->getPost('internalEndingPort', 'int', null, true);
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
