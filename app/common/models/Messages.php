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
class Messages extends \Phalcon\Mvc\Model
{

    const UNACTIVE = 0;
    const ACTIVE = 1;
    const SEEN = 2;

    private $clients;
    private $request;

    /**
     * Initialize message
     *
     * @package     las
     * @version     1.0
     */
    public function onConstruct()
    {
        $this->belongsTo('client_id', __NAMESPACE__ . '\Clients', 'id', [
            'alias' => 'Client'
        ]);

        $this->request = $this->getDI()->getShared('request');
    }

    /**
     * Write method - add the new message
     *
     * @package     las
     * @version     1.0
     *
     * @return mixed
     */
    public function add()
    {
        $validation = new Extension\Validation();

        $validation->add('title', new Validator\StringLength([
            'min' => 3,
            'max' => 64,
            'allowEmpty' => true
        ]));
        $validation->add('client', new Validator\InclusionIn([
            'domain' => array_merge([0], Arr::from_model($this->clients, null, 'id')),
        ]));
        $validation->add('content', new Validator\PresenceOf());
        $validation->add('status', new Validator\InclusionIn([
            'domain' => Messages::status()
        ]));

        $validation->setLabels([
            'title' => __('Title'),
            'client' => __('Client'),
            'content' => __('Content'),
            'status' => __('Status'),
        ]);
        $messages = $validation->validate($_POST);

        // Return messages if validation not pass
        if (count($messages)) {
            return $validation->getMessages();
        } else {
            if ($this->request->getPost('client', 'int') == 0) {
                // Send message to all clients
                foreach ($this->clients as $client) {
                    $message = new Messages();
                    $message->title = $this->request->getPost('title', 'string');
                    $message->client_id = $client->id;
                    $message->content = $this->request->getPost('content', 'string');
                    $message->status = $this->request->getPost('status', 'int');
                    $message->date = date('Y-m-d H:i:s');

                    // Try to write the records
                    if ($message->create() === true) {
                        continue;
                    } else {
                        \Las\Bootstrap::log($this->getMessages());
                        return $this->getMessages();
                    }
                }
                return true;
            } else {
                $this->title = $this->request->getPost('title', 'string');
                $this->client_id = $this->request->getPost('client', 'int');
                $this->content = $this->request->getPost('content', 'string');
                $this->status = $this->request->getPost('status', 'int');
                $this->date = date('Y-m-d H:i:s');

                // Try to write the record
                if ($this->create() === true) {
                    return $this;
                } else {
                    \Las\Bootstrap::log($this->getMessages());
                    return $this->getMessages();
                }
            }
        }
    }

    /**
     * Write method - edit the message
     *
     * @package     las
     * @version     1.0
     *
     * @param string $method type: create/update
     * @return mixed
     */
    public function edit()
    {
        $validation = new Extension\Validation();

        $validation->add('title', new Validator\StringLength([
            'min' => 3,
            'max' => 64,
            'allowEmpty' => true
        ]));
        $validation->add('client', new Validator\InclusionIn([
            'domain' => Arr::from_model($this->clients, null, 'id'),
        ]));
        $validation->add('content', new Validator\PresenceOf());
        $validation->add('status', new Validator\InclusionIn([
            'domain' => Messages::status()
        ]));

        $validation->setLabels([
            'title' => __('Title'),
            'client' => __('Client'),
            'content' => __('Content'),
            'status' => __('Status'),
        ]);
        $messages = $validation->validate($_POST);

        // Return messages if validation not pass
        if (count($messages)) {
            return $validation->getMessages();
        } else {
            $this->title = $this->request->getPost('title', 'string');
            $this->client_id = $this->request->getPost('client', 'int');
            $this->content = $this->request->getPost('content', 'string');
            $this->status = $this->request->getPost('status', 'int');
            $this->date = date('Y-m-d H:i:s');

            // Try to write the records
            if ($this->update() === true) {
                return $this;
            } else {
                \Las\Bootstrap::log($this->getMessages());
                return $this->getMessages();
            }
        }
    }

    /**
     * Get message's status(es)
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
            Messages::UNACTIVE => ['text' => __('Unactive'), 'color' => 'text-muted'],
            Messages::ACTIVE => ['text' => __('Active'), 'color' => 'text-warning'],
            Messages::SEEN => ['text' => __('Seen'), 'color' => 'text-success'],
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

}
