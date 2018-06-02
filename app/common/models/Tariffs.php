<?php

namespace Las\Models;

use Phalcon\Validation\Validator;

/**
 * Tariffs Model
 *
 * @package     las
 * @category    Model
 * @version     1.0
 */
class Tariffs extends \Phalcon\Mvc\Model
{

    const UNACTIVE = 0;
    const ACTIVE = 1;

    private $request;

    /**
     * Initialize tariff
     *
     * @package     las
     * @version     1.0
     */
    public function onConstruct()
    {
        $this->hasMany('id', __NAMESPACE__ . '\Clients', 'tariff_id', [
            'alias' => 'Clients'
        ]);

        $this->request = $this->getDI()->getShared('request');
    }

    /**
     * Get available rate for download/upload
     *
     * @package     las
     * @version     1.0
     *
     * @param mixed $type type of rate
     * @return int
     */
    public static function rate($type)
    {
        $tariffs = Tariffs::find(['status=:status:', 'bind' => ['status' => Tariffs::ACTIVE]]);
        $rate = 0;
        $typeRate = $type . 'Rate';

        foreach ($tariffs as $tariff) {
            $rate += $tariff->$typeRate;
        }

        return Networks::ceil($type) - $rate;
    }

    /**
     * Get tariff's status(es)
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
            Tariffs::UNACTIVE => ['text' => __('Unactive'), 'color' => 'text-muted'],
            Tariffs::ACTIVE => ['text' => __('Active'), 'color' => 'text-success'],
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
     * Write method - add/edit the tariff
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

        $validation->add('name', new Validator\PresenceOf());
        $validation->add('name', new Validator\StringLength([
            'min' => 3,
            'max' => 32,
        ]));
        $validation->add('amount', new Validator\PresenceOf());
        $validation->add('amount', new Validator\Regex([
            'pattern' => '/\d+(\.\d{2})?/'
        ]));
        $validation->add('priority', new Validator\Between([
            'minimum' => 10,
            'maximum' => 99,
        ]));
        $validation->add('downloadRate', new Validator\Between([
            'minimum' => 0,
            'maximum' => Tariffs::rate('download'),
        ]));
        $validation->add('downloadCeil', new Validator\Between([
            'minimum' => 0,
            'maximum' => Networks::ceil('download'),
        ]));
        $validation->add('uploadRate', new Validator\Between([
            'minimum' => 0,
            'maximum' => Tariffs::rate('upload'),
        ]));
        $validation->add('uploadCeil', new Validator\Between([
            'minimum' => 0,
            'maximum' => Networks::ceil('upload'),
        ]));
        $validation->add('limit', new Validator\Regex([
            'allowEmpty' => true,
            'pattern' => '/\d+/'
        ]));
        $validation->add('description', new Validator\StringLength([
            'max' => 1024,
        ]));
        $validation->add('status', new Validator\InclusionIn([
            'domain' => Tariffs::status()
        ]));

        $validation->setLabels([
            'name' => __('Name'),
            'amount' => __('Amount'),
            'priority' => __('Priority'),
            'downloadRate' => __('Download rate'),
            'downloadCeil' => __('Download ceil'),
            'uploadRate' => __('Upload rate'),
            'uploadCeil' => __('Upload ceil'),
            'limit' => __('Limit'),
            'description' => __('Description'),
            'status' => __('Status'),
        ]);
        $messages = $validation->validate($_POST);

        // Return messages if validation not pass
        if (count($messages)) {
            return $validation->getMessages();
        } else {
            $this->name = $this->request->getPost('name', 'string');
            $this->amount = $this->request->getPost('amount');
            $this->priority = $this->request->getPost('priority', 'int');
            $this->downloadRate = $this->request->getPost('downloadRate', 'float');
            $this->downloadCeil = $this->request->getPost('downloadCeil', 'float');
            $this->uploadRate = $this->request->getPost('uploadRate', 'float');
            $this->uploadCeil = $this->request->getPost('uploadCeil', 'float');
            $this->limit = $this->request->getPost('limit', 'int', null, ture);
            $this->description = $this->request->getPost('description');
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
