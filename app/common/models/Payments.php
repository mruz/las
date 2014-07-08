<?php

namespace Las\Models;

use Las\Extension;
use Las\Library\Arr;
use Phalcon\Validation\Validator;

/**
 * Payment Model
 *
 * @package     las
 * @category    Model
 * @version     1.0
 */
class Payments extends \Phalcon\Mvc\Model
{

    const PENDING = 0;
    const SUCCESS = 1;

    private $clients;
    private $request;

    /**
     * Initialize payment
     *
     * @package     las
     * @version     1.0
     */
    public function initialize()
    {
        $this->belongsTo('client_id', __NAMESPACE__ . '\Clients', 'id', [
            'alias' => 'Client'
        ]);

        $this->request = $this->getDI()->getShared('request');
    }

    /**
     * Get payment's status(es)
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
            Payments::PENDING => ['text' => __('Pending'), 'color' => 'text-muted'],
            Payments::SUCCESS => ['text' => __('Success'), 'color' => 'text-success'],
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
     * Write method - add/edit the payment
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

        $validation->add('client', new Validator\PresenceOf());
        $validation->add('client', new Validator\InclusionIn([
            'domain' => Arr::from_model($this->clients, NULL, 'id'),
        ]));
        $validation->add('amount', new Validator\PresenceOf());
        $validation->add('amount', new Validator\Regex([
            'pattern' => '/[-]?\d+(\.\d{2})?/'
        ]));
        $validation->add('description', new Validator\StringLength([
            'max' => 1024,
        ]));
        $validation->add('status', new Validator\InclusionIn([
            'domain' => Payments::status()
        ]));

        $validation->setLabels([
            'client' => __('Client'),
            'amount' => __('Amount'),
            'description' => __('Description'),
            'status' => __('Status'),
        ]);
        $messages = $validation->validate($_POST);

        // Return messages if validation not pass
        if (count($messages)) {
            return $validation->getMessages();
        } else {
            $this->client_id = $this->request->getPost('client', 'int');
            $this->amount = $this->request->getPost('amount');
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
