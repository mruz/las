<?php

namespace Las\Models;

use Las\Extension;
use Las\Library\Arr;
use Phalcon\Validation\Validator;

/**
 * Devices Model
 *
 * @package     las
 * @category    Model
 * @version     1.0
 */
class Devices extends \Phalcon\Mvc\Model
{

    const UNACTIVE = 0;
    const ACTIVE = 1;
    const PC = 1;
    const NOTEBOOK = 2;
    const TV = 3;
    const GAMECONSOLE = 4;
    const MOBILEPHONE = 5;
    const TABLET = 6;
    const ROUTER = 7;
    const VOIP = 8;
    const EQUIPMENT = 9;

    private $clients;
    private $networks;
    private $request;

    /**
     * Initialize device
     *
     * @package     las
     * @version     1.0
     */
    public function initialize()
    {
        $this->belongsTo('client_id', __NAMESPACE__ . '\Clients', 'id', [
            'alias' => 'Client'
        ]);
        $this->hasMany('id', __NAMESPACE__ . '\Redirects', 'device_id', [
            'alias' => 'Redirects'
        ]);
        $this->hasMany('id', __NAMESPACE__ . '\Services', 'device_id', [
            'alias' => 'Services'
        ]);

        $this->request = $this->getDI()->getShared('request');
    }

    /**
     * Get device's lastActive
     *
     * @package     las
     * @version     1.0
     *
     * @param mixed $time timestamp
     * @param string $type type of data
     * @return mixed
     */
    public static function lastActive($time = null, $type = 'time')
    {
        switch ($time) {
            case null:
                return $type == 'time' ? __('None') : 'text-danger';
                break;
            default:
                if (time() - $time < 900) {
                    return $type == 'time' ? date('Y-m-d H:i:s', $time) : 'text-success';
                } else {
                    return $type == 'time' ? date('Y-m-d H:i:s', $time) : 'text-muted';
                }
        }
    }

    /**
     * Get device's status(es)
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
            Devices::UNACTIVE => ['text' => __('Unactive'), 'color' => 'text-muted'],
            Devices::ACTIVE => ['text' => __('Active'), 'color' => 'text-success'],
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
     * Get device's type(s)
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
            Devices::PC => __('PC'),
            Devices::NOTEBOOK => __('Notebook'),
            Devices::TV => __('TV'),
            Devices::GAMECONSOLE => __('Game console'),
            Devices::MOBILEPHONE => __('Mobile phone'),
            Devices::TABLET => __('Tablet'),
            Devices::ROUTER => __('Router'),
            Devices::VOIP => __('Voip'),
            Devices::EQUIPMENT => __('Equipment'),
        ];
        if ($key !== false) {
            return $key === true ? $type : $type[$key];
        } else {
            return array_keys($type);
        }
    }

    /**
     * Write method - add/edit the device
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

        $this->getDI()->getShared('filter')->add('mac', function($mac) {
            return strtoupper(str_replace('-', ':', $mac));
        });

        $validation->add('name', new Validator\PresenceOf());
        $validation->add('name', new Validator\StringLength([
            'min' => 3,
            'max' => 32,
        ]));
        $validation->add('name', new Validator\Regex([
            'pattern' => '/([A-Z][A-Z0-9_-]{2,})/'
        ]));
        $validation->add('network', new Validator\PresenceOf());
        $validation->add('network', new Validator\InclusionIn([
            'domain' => Arr::from_model($this->networks, null, 'id'),
        ]));
        $validation->add('client', new Validator\PresenceOf());
        $validation->add('client', new Validator\InclusionIn([
            'domain' => Arr::from_model($this->clients, null, 'id'),
        ]));
        $validation->add('type', new Validator\PresenceOf());
        $validation->add('type', new Validator\InclusionIn([
            'domain' => Devices::type()
        ]));
        $validation->add('IP', new Validator\PresenceOf());
        $validation->add('IP', new Extension\Ip([
            'value' => $this->request->getPost('IP')
        ]));
        $validation->add('IP', new Validator\ExclusionIn([
            'domain' => Arr::from_model($this->networks, null, 'IP'),
            'message' => __('Field :field is reserved')
        ]));
        $validation->add('IP', new Extension\Uniqueness([
            'model' => __CLASS__,
            'except' => $this->IP
        ]));
        $network = Networks::findFirst($this->request->getPost('network', 'int'));
        $validation->add('IP', new Extension\Cidr([
            'cidr' => $network->subnetwork . $network->mask,
        ]));
        $validation->add('MAC', new Validator\PresenceOf());
        $validation->add('MAC', new Validator\Regex([
            'pattern' => '/([0-9a-fA-F]{2}[:|\-]){5}[0-9a-fA-F]{2}/'
        ]));
        $validation->add('MAC', new Extension\Uniqueness([
            'model' => __CLASS__,
            'except' => $this->MAC
        ]));
        $validation->add('description', new Validator\StringLength([
            'max' => 1024,
        ]));
        $validation->add('status', new Validator\InclusionIn([
            'domain' => Devices::status()
        ]));

        $validation->setFilters('IP', 'ip2long');
        $validation->setFilters('MAC', 'mac');

        $validation->setLabels([
            'name' => __('Name'),
            'network' => __('Network'),
            'client' => __('Client'),
            'type' => __('Type'),
            'IP' => __('IP'),
            'MAC' => __('MAC'),
            'description' => __('Description'),
            'status' => __('Status'),
        ]);
        $messages = $validation->validate($_POST);

        // Return messages if validation not pass
        if (count($messages)) {
            return $validation->getMessages();
        } else {
            $this->name = $this->request->getPost('name', 'string');
            $this->network_id = $this->request->getPost('network', 'int');
            $this->client_id = $this->request->getPost('client', 'int');
            $this->type = $this->request->getPost('type', 'int');
            $this->IP = $this->request->getPost('IP', 'ip2long');
            $this->MAC = $this->request->getPost('MAC', 'mac');
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
