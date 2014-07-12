<?php

namespace Las\Models;

use Las\Extension;
use Phalcon\Validation\Validator;

/**
 * Networks Model
 *
 * @package     las
 * @category    Model
 * @version     1.0
 */
class Networks extends \Phalcon\Mvc\Model
{

    const UNACTIVE = 0;
    const ACTIVE = 1;
    const WAN = 1;
    const LAN = 2;

    private $request;

    /**
     * Initialize network
     *
     * @package     las
     * @version     1.0
     */
    public function initialize()
    {
        $this->hasMany('id', __NAMESPACE__ . '\Devices', 'network_id', [
            'alias' => 'Devices'
        ]);
        $this->hasMany('id', __NAMESPACE__ . '\Tariffs', 'network_id', [
            'alias' => 'Tariffs'
        ]);

        $this->request = $this->getDI()->getShared('request');
    }

    /**
     * Get available ceil for download/upload
     *
     * @package     las
     * @version     1.0
     *
     * @param mixed $type type of ceil
     * @return int
     */
    public static function ceil($type)
    {
        $wans = Networks::find(['type=:type: AND status=:status:', 'bind' => ['type' => Networks::WAN, 'status' => Networks::ACTIVE]]);
        $ceil = 0;

        foreach ($wans as $wan) {
            $ceil += $wan->$type;
        }

        return $ceil;
    }

    /**
     * Get mask(s)
     *
     * @package     las
     * @version     1.0
     *
     * @param mixed $cidr key to get mask
     * @param string $type type of data
     * @return mixed
     */
    public static function mask($cidr = null, $type = 'mask')
    {
        $cidrs = [
            '/1' => ['mask' => '128.0.0.0', 'hosts' => 2147483646],
            '/2' => ['mask' => '192.0.0.0', 'hosts' => 1073741822],
            '/3' => ['mask' => '224.0.0.0', 'hosts' => 536870910],
            '/4' => ['mask' => '240.0.0.0', 'hosts' => 268435454],
            '/5' => ['mask' => '248.0.0.0', 'hosts' => 134217726],
            '/6' => ['mask' => '252.0.0.0', 'hosts' => 67108862],
            '/7' => ['mask' => '254.0.0.0', 'hosts' => 33554430],
            '/8' => ['mask' => '255.0.0.0', 'hosts' => 16777214],
            '/9' => ['mask' => '255.128.0.0', 'hosts' => 8388606],
            '/10' => ['mask' => '255.192.0.0', 'hosts' => 4194302],
            '/11' => ['mask' => '255.224.0.0', 'hosts' => 2097150],
            '/12' => ['mask' => '255.240.0.0', 'hosts' => 1048574],
            '/13' => ['mask' => '255.248.0.0', 'hosts' => 524286],
            '/14' => ['mask' => '255.252.0.0', 'hosts' => 262142],
            '/15' => ['mask' => '255.254.0.0', 'hosts' => 131070],
            '/16' => ['mask' => '255.255.0.0', 'hosts' => 65534],
            '/17' => ['mask' => '255.255.128.0', 'hosts' => 32766],
            '/18' => ['mask' => '255.255.192.0', 'hosts' => 16382],
            '/19' => ['mask' => '255.255.224.0', 'hosts' => 8190],
            '/20' => ['mask' => '255.255.240.0', 'hosts' => 4094],
            '/21' => ['mask' => '255.255.248.0', 'hosts' => 2046],
            '/22' => ['mask' => '255.255.252.0', 'hosts' => 1022],
            '/23' => ['mask' => '255.255.254.0', 'hosts' => 510],
            '/24' => ['mask' => '255.255.255.0', 'hosts' => 254],
            '/25' => ['mask' => '255.255.255.128', 'hosts' => 126],
            '/26' => ['mask' => '255.255.255.192', 'hosts' => 62],
            '/27' => ['mask' => '255.255.255.224', 'hosts' => 30],
            '/28' => ['mask' => '255.255.255.240', 'hosts' => 14],
            '/29' => ['mask' => '255.255.255.248', 'hosts' => 6],
            '/30' => ['mask' => '255.255.255.252', 'hosts' => 2],
        ];

        if ($cidr) {
            return $cidrs[$cidr][$type];
        } else {
            $array = [];

            foreach ($cidrs as $cidr => $values) {
                $array [$cidr] = $values[$type];
            }
            return $array;
        }
    }

    /**
     * Get network's status(es)
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
            Networks::UNACTIVE => ['text' => __('Unactive'), 'color' => 'text-muted'],
            Networks::ACTIVE => ['text' => __('Active'), 'color' => 'text-success'],
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
     * Get network's type(s)
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
            Networks::WAN => __('WAN'),
            Networks::LAN => __('LAN'),
        ];
        if ($key !== false) {
            return $key === true ? $type : $type[$key];
        } else {
            return array_keys($type);
        }
    }

    /**
     * Write method - add/edit the network
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
        $validation->add('interface', new Validator\PresenceOf());
        $validation->add('interface', new Validator\StringLength([
            'max' => 32,
        ]));
        $validation->add('interface', new Extension\Uniqueness([
            'model' => __CLASS__,
            'except' => isset($this->interface) ? $this->interface : null
        ]));
        $validation->add('subnetwork', new Validator\PresenceOf());
        $validation->add('subnetwork', new Extension\Ip([
            'value' => $this->request->getPost('subnetwork')
        ]));
        $validation->add('subnetwork', new Extension\Uniqueness([
            'model' => __CLASS__,
            'except' => isset($this->subnetwork) ? $this->subnetwork : null
        ]));
        $validation->add('type', new Validator\PresenceOf());
        $validation->add('type', new Validator\InclusionIn([
            'domain' => Networks::type()
        ]));
        $validation->add('IP', new Validator\PresenceOf());
        $validation->add('IP', new Extension\Ip([
            'value' => $this->request->getPost('IP')
        ]));
        $validation->add('IP', new Extension\Uniqueness([
            'model' => __CLASS__,
            'except' => isset($this->IP) ? $this->IP : null
        ]));
        $validation->add('gateway', new Validator\PresenceOf());
        $validation->add('gateway', new \Las\Extension\Ip([
            'value' => $this->request->getPost('gateway')
        ]));
        $validation->add('DNS', new Extension\Dns([
            'allowEmpty' => true
        ]));
        $validation->add('DNS', new Extension\Together([
            'with' => ['type' => Networks::WAN],
            'allowEmpty' => true
        ]));
        $validation->add('DHCP', new Extension\Dhcp([
            'allowEmpty' => true
        ]));
        $validation->add('DHCP', new Extension\Together([
            'with' => ['type' => Networks::LAN],
            'allowEmpty' => true
        ]));
        $validation->add('mask', new Validator\InclusionIn([
            'domain' => array_keys(Networks::mask()),
        ]));
        $validation->add('download', new Validator\Between([
            'minimum' => 0,
            'maximum' => 1000,
        ]));
        $validation->add('upload', new Validator\Between([
            'minimum' => 0,
            'maximum' => 1000,
        ]));
        $validation->add('description', new Validator\StringLength([
            'max' => 1024,
        ]));
        $validation->add('status', new Validator\InclusionIn([
            'domain' => Networks::status()
        ]));

        $validation->setFilters('subnetwork', 'ip2long');
        $validation->setFilters('IP', 'ip2long');
        $validation->setFilters('gateway', 'ip2long');

        $validation->setLabels([
            'name' => __('Name'),
            'interface' => __('Interface'),
            'subnetwork' => __('Subnetwork'),
            'type' => __('Type'),
            'IP' => __('IP'),
            'gateway' => __('Gateway'),
            'DNS' => __('DNS'),
            'DHCP' => __('DHCP'),
            'mask' => __('Mask'),
            'download' => __('Download'),
            'upload' => __('Upload'),
            'description' => __('Description'),
            'status' => __('Status'),
        ]);
        $messages = $validation->validate($_POST);

        // Return messages if validation not pass
        if (count($messages)) {
            return $validation->getMessages();
        } else {
            $this->name = $this->request->getPost('name', 'string');
            $this->interface = $this->request->getPost('interface', 'string');
            $this->subnetwork = $this->request->getPost('subnetwork', 'ip2long');
            $this->type = $this->request->getPost('type', 'int');
            $this->IP = $this->request->getPost('IP', 'ip2long');
            $this->mask = $this->request->getPost('mask', 'string');
            $this->gateway = $this->request->getPost('gateway', 'ip2long');
            $this->DNS = $this->request->getPost('DNS', 'string');
            $this->DHCP = $this->request->getPost('DHCP', 'string');
            $this->download = $this->request->getPost('download', 'int', 0, true);
            $this->upload = $this->request->getPost('upload', 'int', 0, true);
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
