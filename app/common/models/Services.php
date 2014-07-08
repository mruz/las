<?php

namespace Las\Models;

use Las\Extension;
use Las\Library\Arr;
use Phalcon\Validation\Validator;

/**
 * Services Model
 *
 * @package     las
 * @category    Model
 * @version     1.0
 */
class Services extends \Phalcon\Mvc\Model
{

    const UNACTIVE = 0;
    const ACTIVE = 1;
    const SOURCE = 1;
    const DESTINATION = 2;
    const BOTH = 3;
    const TCP = 1;
    const UDP = 2;
    const INPUT = 1;
    const OUTPUT = 2;
    const FORWARD = 3;
    const DISABLED = 0;
    const HIGHEST = 1;
    const HIGH = 2;
    const MEDIUM = 3;
    const LOW = 4;
    const LOWEST = 5;

    private $clients;
    private $devices;
    private $request;

    /**
     * Initialize service
     *
     * @package     las
     * @version     1.0
     */
    public function initialize()
    {
        $this->belongsTo('client_id', __NAMESPACE__ . '\Clients', 'id', [
            'alias' => 'Client'
        ]);
        $this->belongsTo('device_id', __NAMESPACE__ . '\Devices', 'id', [
            'alias' => 'Device'
        ]);

        $this->request = $this->getDI()->getShared('request');
    }

    /**
     * Get service's chain(s)
     *
     * @package     las
     * @version     1.0
     *
     * @param mixed $key key to get chain
     * @return mixed
     */
    public static function chain($key = false)
    {
        $chain = [
            Services::INPUT => __('INPUT'),
            Services::OUTPUT => __('OUTPUT'),
            Services::FORWARD => __('FORWARD'),
        ];
        if ($key !== false) {
            return $key === true ? $chain : $chain[$key];
        } else {
            return array_keys($chain);
        }
    }

    /**
     * Get service's direction(s)
     *
     * @package     las
     * @version     1.0
     *
     * @param mixed $key key to get direction
     * @return mixed
     */
    public static function direction($key = false, $type = 'text')
    {
        $direction = [
            Services::SOURCE => ['text' => __('Source'), 'rule' => 's'],
            Services::DESTINATION => ['text' => __('Destination'), 'rule' => 'd'],
        ];
        if ($key !== false) {
            if ($key !== true) {
                return $direction[$key][$type];
            } else {
                $array = [];

                foreach ($direction as $key => $value) {
                    $array [$key] = $value[$type];
                }
                return $array;
            }
        } else {
            return array_keys($direction);
        }
    }

    /**
     * Get service's port direction(s)
     *
     * @package     las
     * @version     1.0
     *
     * @param mixed $key key to get port direction
     * @return mixed
     */
    public static function portDirection($key = false, $type = 'text')
    {
        $direction = [
            Services::SOURCE => ['text' => __('Source'), 'rule' => 'sport'],
            Services::DESTINATION => ['text' => __('Destination'), 'rule' => 'dport'],
            Services::BOTH => ['text' => __('Both'), 'rule' => 'port'],
        ];
        if ($key !== false) {
            if ($key !== true) {
                return $direction[$key][$type];
            } else {
                $array = [];

                foreach ($direction as $key => $value) {
                    $array [$key] = $value[$type];
                }
                return $array;
            }
        } else {
            return array_keys($direction);
        }
    }

    /**
     * Get service's priority(s)
     *
     * @package     las
     * @version     1.0
     *
     * @param mixed $key key to get priority
     * @return mixed
     */
    public static function priority($key = false, $type = 'text')
    {
        $priority = [
            Services::DISABLED => ['text' => __('Disabled'), 'name' => 'disabled'],
            Services::HIGHEST => ['text' => __('Highest'), 'name' => 'highest'],
            Services::HIGH => ['text' => __('High'), 'name' => 'high'],
            Services::MEDIUM => ['text' => __('Medium'), 'name' => 'medium'],
            Services::LOW => ['text' => __('Low'), 'name' => 'low'],
            Services::LOWEST => ['text' => __('Lowest'), 'name' => 'lowest'],
        ];
        $settings = Arr::from_model(Settings::find('category="qos"'), 'name', 'value');
        foreach ($priority as $prio => $values) {
            $priority[$prio]['rate'] = isset($settings[$values['name'] . 'Rate']) ? $settings[$values['name'] . 'Rate'] : null;
            $priority[$prio]['ceil'] = isset($settings[$values['name'] . 'Ceil']) ? $settings[$values['name'] . 'Ceil'] : null;
        }
        if ($key === null) {
            return $priority;
        } elseif ($key !== false) {
            if ($key !== true) {
                return $priority[$key][$type];
            } else {
                $array = [];

                foreach ($priority as $key => $value) {
                    $array [$key] = $value[$type];
                }
                return $array;
            }
        } else {
            return array_keys($priority);
        }
    }

    /**
     * Get service's protocol(s)
     *
     * @package     las
     * @version     1.0
     *
     * @param mixed $key key to get protocol
     * @return mixed
     */
    public static function protocol($key = false)
    {
        $type = [
            Services::TCP => __('TCP'),
            Services::UDP => __('UDP'),
        ];
        if ($key !== false) {
            return $key === true ? $type : $type[$key];
        } else {
            return array_keys($type);
        }
    }

    /**
     * Get available rate for priority
     *
     * @package     las
     * @version     1.0
     *
     * @param mixed $field sum rate until the field
     * @return int
     */
    public static function rate($field)
    {
        $rate = 0;
        foreach (['highest', 'high', 'medium', 'low', 'lowest'] as $name) {
            $available = 100 - $rate;
            $rate += $_POST[$name . 'Rate'];
            if ($name . 'Rate' == $field) {
                break;
            }
        }
        return $available > 0 ? $available : 0;
    }

    /**
     * Get service's status(es)
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
            Services::UNACTIVE => ['text' => __('Unactive'), 'color' => 'text-muted'],
            Services::ACTIVE => ['text' => __('Active'), 'color' => 'text-success'],
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
     * Write method - add/edit the service
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
        $validation->add('chain', new Validator\PresenceOf());
        $validation->add('chain', new Validator\InclusionIn([
            'domain' => Services::chain(),
            'message' => __('Field :field must be a part of list: :domain', [':domain' => join(', ', Services::chain(true))])
        ]));
        $validation->add('protocol', new Validator\InclusionIn([
            'domain' => Services::protocol(),
            'allowEmpty' => true
        ]));
        $validation->add('direction', new Extension\Together([
            'withOr' => ['client', 'device', 'IP'],
            'allowEmpty' => true
        ]));
        $validation->add('client', new Extension\Together([
            'with' => ['direction'],
            'without' => ['device', 'IP'],
            'allowEmpty' => true
        ]));
        $validation->add('device', new Extension\Together([
            'with' => ['direction'],
            'without' => ['IP'],
            'allowEmpty' => true
        ]));
        $validation->add('IP', new Extension\Together([
            'with' => ['direction'],
            'allowEmpty' => true
        ]));
        $validation->add('client', new Validator\InclusionIn([
            'domain' => Arr::from_model($this->clients, null, 'id'),
            'allowEmpty' => true
        ]));
        $validation->add('device', new Validator\InclusionIn([
            'domain' => Arr::from_model($this->devices, null, 'id'),
            'allowEmpty' => true
        ]));
        $validation->add('IP', new Extension\Ip([
            'value' => $this->request->getPost('IP'),
            'allowEmpty' => true
        ]));
        $validation->add('string', new Validator\StringLength([
            'max' => 128,
        ]));
        $validation->add('portDirection', new Extension\Together([
            'with' => ['startingPort'],
            'allowEmpty' => true
        ]));
        $validation->add('startingPort', new Validator\StringLength([
            'max' => 16,
        ]));
        $validation->add('startingPort', new Extension\Together([
            'with' => ['portDirection'],
            'allowEmpty' => true
        ]));
        $validation->add('endingPort', new Validator\Between([
            'minimum' => 1,
            'maximum' => 65535,
            'allowEmpty' => true
        ]));
        $validation->add('endingPort', new Extension\Together([
            'with' => ['startingPort'],
            'allowEmpty' => true
        ]));
        $validation->add('priority', new Validator\InclusionIn([
            'domain' => Services::priority()
        ]));
        $validation->add('sorting', new Validator\Between([
            'minimum' => 1,
            'maximum' => 65535,
            'allowEmpty' => true
        ]));
        $validation->add('description', new Validator\StringLength([
            'max' => 1024,
        ]));
        $validation->add('status', new Validator\InclusionIn([
            'domain' => Services::status()
        ]));

        $validation->setFilters('IP', 'ip2long');

        $validation->setLabels([
            'name' => __('Name'),
            'chain' => __('Chain'),
            'protocol' => __('Protocol'),
            'direction' => __('Direction'),
            'client' => __('Client'),
            'device' => __('Device'),
            'IP' => __('IP'),
            'string' => __('String'),
            'portDirection' => __('Port direction'),
            'startingPort' => __('Starting port'),
            'endingPort' => __('Ending port'),
            'lengthEnd' => __('Length end'),
            'lengthStart' => __('Length start'),
            'priority' => __('Priority'),
            'sorting' => __('Sorting'),
            'description' => __('Description'),
            'status' => __('Status'),
        ]);
        $messages = $validation->validate($_POST);

        // Return messages if validation not pass
        if (count($messages)) {
            return $validation->getMessages();
        } else {
            $this->name = $this->request->getPost('name', 'string');
            $this->chain = $this->request->getPost('chain', 'int');
            $this->protocol = $this->request->getPost('protocol', 'int', null, true);
            $this->direction = $this->request->getPost('direction', 'int', null, true);
            $this->client_id = $this->request->getPost('client', 'int', 0, true);
            $this->device_id = $this->request->getPost('device', 'int', 0, true);
            $this->IP = $this->request->getPost('IP', 'ip2long');

            $this->portDirection = $this->request->getPost('portDirection', 'int');
            $this->startingPort = $this->request->getPost('startingPort', 'string', null, true);
            $this->endingPort = $this->request->getPost('endingPort', 'int', null, true);

            $this->internalStartingPort = $this->request->getPost('internalStartingPort', 'int', null, true);
            $this->internalEndingPort = $this->request->getPost('internalEndingPort', 'int', null, true);

            $this->priority = $this->request->getPost('priority', 'int', 0, true);
            $this->sorting = $this->request->getPost('sorting', 'int', 100, true);
            $this->description = $this->request->getPost('description', 'string', null, true);
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
