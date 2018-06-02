<?php

namespace Las\Models;

use Las\Extension;
use Las\Library\Arr;
use Phalcon\Validation\Validator;

/**
 * Tasks Model
 *
 * @package     las
 * @category    Model
 * @version     1.0
 */
class Tasks extends \Phalcon\Mvc\Model
{

    const UNACTIVE = 0;
    const ACTIVE = 1;
    const RELOAD = 2;
    const FIREWALL = 1;
    const CUTOFF = 2;
    const PAYMENT = 3;
    const PING = 4;

    private $firewalls;
    private $request;

    /**
     * Initialize task
     *
     * @package     las
     * @version     1.0
     */
    public function onConstruct()
    {
        $this->belongsTo('firewall_id', __NAMESPACE__ . '\Firewalls', 'id', [
            'alias' => 'Firewall'
        ]);

        $this->request = $this->getDI()->getShared('request');
    }

    /**
     * Get task's status(es)
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
            Tasks::UNACTIVE => ['text' => __('Unactive'), 'color' => 'text-muted'],
            Tasks::ACTIVE => ['text' => __('Active'), 'color' => 'text-success'],
            Tasks::RELOAD => ['text' => __('Reload'), 'color' => 'text-success'],
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
     * Get task's type(s)
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
            Tasks::FIREWALL => __('Firewall'),
            Tasks::CUTOFF => __('Cut off'),
            Tasks::PAYMENT => __('Payment'),
            Tasks::PING => __('Ping'),
        ];
        if ($key !== false) {
            return $key === true ? $type : $type[$key];
        } else {
            return array_keys($type);
        }
    }

    /**
     * Write method - add/edit the task
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
        $validation->setDefaultMessages([
            'TogetherWith' => 'Field :field must occur together with :with',
            'TogetherWithOr' => 'Field :field must occur together with one of: :with',
            'TogetherWithout' => 'Field :field must not occur together with :with',
        ]);

        $validation->add('name', new Validator\PresenceOf());
        $validation->add('name', new Validator\StringLength([
            'max' => 32,
        ]));
        $validation->add('when', new Validator\PresenceOf());
        $validation->add('when', new Validator\StringLength([
            'max' => 64,
        ]));
        $validation->add('type', new Validator\PresenceOf());
        $validation->add('type', new Validator\InclusionIn([
            'domain' => Tasks::type()
        ]));
        if ($this->request->getPost('type', 'int') == Tasks::FIREWALL) {
            $validation->add('type', new Extension\Together([
                'with' => ['firewall'],
            ]));
        }
        $validation->add('firewall', new Extension\Together([
            'with' => ['type' => Tasks::FIREWALL],
            'allowEmpty' => true
        ]));
        $validation->add('firewall', new Validator\InclusionIn([
            'domain' => Arr::from_model($this->firewalls, null, 'id'),
            'allowEmpty' => true
        ]));
        $validation->add('next', new Validator\Regex([
            'pattern' => '/\d{4}-\d{2}-\d{2} \d{2}:\d{2}/',
            'message' => 'Required format: YYYY-MM-DD hh:mm',
            'allowEmpty' => true
        ]));
        $validation->add('description', new Validator\StringLength([
            'max' => 1024,
        ]));
        $validation->add('status', new Validator\InclusionIn([
            'domain' => Tasks::status()
        ]));

        $validation->setLabels([
            'name' => __('Name'),
            'when' => __('When'),
            'type' => __('Type'),
            'firewall' => __('Firewall'),
            'next' => __('Next'),
            'description' => __('Description'),
            'status' => __('Status'),
        ]);
        $messages = $validation->validate($_POST);

        // Return messages if validation not pass
        if (count($messages)) {
            return $validation->getMessages();
        } else {
            $this->name = $this->request->getPost('name', 'string');
            $this->when = $this->request->getPost('when', 'string');
            $this->type = $this->request->getPost('type', 'int');
            $this->firewall_id = $this->request->getPost('firewall', 'int', 0, true);
            $this->next = strtotime($this->request->getPost('next', 'string'));
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
