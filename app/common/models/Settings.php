<?php

namespace Las\Models;

use Las\Library\Arr;
use Phalcon\Validation\Validator;

/**
 * Settings Model
 *
 * @package     las
 * @category    Model
 * @version     1.0
 */
class Settings extends \Phalcon\Mvc\Model
{

    const UNACTIVE = 0;
    const ACTIVE = 1;
    const TEXT = 1;
    const PASSWORD = 2;
    const CHECK = 3;
    const AREA = 4;
    const SELECT = 5;

    /**
     * General method - save general settings
     *
     * @package     las
     * @version     1.0
     */
    public static function general($settings)
    {
        $validation = new \Las\Extension\Validation();

        $validation->add('bitRate', new Validator\InclusionIn(array(
            'domain' => array_keys(Settings::options('bitRate', null, $settings)),
        )));
        $validation->add('port', new Validator\Between([
            'minimum' => 1,
            'maximum' => 65535,
        ]));
        $validation->add('rootPassword', new \Las\Extension\Root(array(
            'allowEmpty' => true
        )));

        $validation->setLabels([
            'bitRate' => __('Bit rate'),
            'port' => __('Port'),
            'rootPassword' => __('Root password'),
        ]);

        return Settings::updateSettings($settings, $validation);
    }

    /**
     * Options method - get  option value(s)
     *
     * @package     las
     * @version     1.0
     */
    public static function options($name, $value = null, $settings = null)
    {
        if ($settings === null) {
            $settings = Settings::find();
        }
        $options = json_decode(Arr::from_model($settings, 'name')[$name]['options'], true);
        return $value ? $options[$value] : $options;
    }

    /**
     * Payments method - save payments settings
     *
     * @package     las
     * @version     1.0
     */
    public static function payments($settings)
    {
        $validation = new \Las\Extension\Validation();

        $validation->add('currency', new Validator\InclusionIn(array(
            'domain' => array_keys(Settings::options('currency', null, $settings)),
        )));

        $validation->setLabels(array('currency' => __('Currency')));

        return Settings::updateSettings($settings, $validation);
    }

    /**
     * Qos method - save Qos settings
     *
     * @package     las
     * @version     1.0
     */
    public static function qos($settings)
    {
        $validation = new \Las\Extension\Validation();
        $validation->add('defaultClass', new Validator\InclusionIn(array(
            'domain' => Services::priority(),
        )));
        $validation->add('enableQos', new Validator\InclusionIn(array(
            'domain' => [0, 1],
        )));
        $validation->add('highestRate', new Validator\InclusionIn(array(
            'domain' => array_keys(Settings::options('highestRate', null, $settings)),
        )));
        $validation->add('highestRate', new Validator\Between(array(
            'minimum' => 1,
            'maximum' => Services::rate('highestRate'),
        )));
        $validation->add('highestCeil', new Validator\InclusionIn(array(
            'domain' => array_keys(Settings::options('highestCeil', null, $settings)),
        )));
        $validation->add('highRate', new Validator\InclusionIn(array(
            'domain' => array_keys(Settings::options('highRate', null, $settings)),
        )));
        $validation->add('highRate', new Validator\Between(array(
            'minimum' => 1,
            'maximum' => Services::rate('highRate'),
        )));
        $validation->add('highCeil', new Validator\InclusionIn(array(
            'domain' => array_keys(Settings::options('highCeil', null, $settings)),
        )));
        $validation->add('mediumRate', new Validator\InclusionIn(array(
            'domain' => array_keys(Settings::options('mediumRate', null, $settings)),
        )));
        $validation->add('mediumRate', new Validator\Between(array(
            'minimum' => 1,
            'maximum' => Services::rate('mediumRate'),
        )));
        $validation->add('mediumCeil', new Validator\InclusionIn(array(
            'domain' => array_keys(Settings::options('mediumCeil', null, $settings)),
        )));
        $validation->add('lowRate', new Validator\InclusionIn(array(
            'domain' => array_keys(Settings::options('lowRate', null, $settings)),
        )));
        $validation->add('lowRate', new Validator\Between(array(
            'minimum' => 1,
            'maximum' => Services::rate('lowRate'),
        )));
        $validation->add('lowCeil', new Validator\InclusionIn(array(
            'domain' => array_keys(Settings::options('lowCeil', null, $settings)),
        )));
        $validation->add('lowestRate', new Validator\InclusionIn(array(
            'domain' => array_keys(Settings::options('lowestRate', null, $settings)),
        )));
        $validation->add('lowestRate', new Validator\Between(array(
            'minimum' => 1,
            'maximum' => Services::rate('lowestRate'),
        )));
        $validation->add('lowestCeil', new Validator\InclusionIn(array(
            'domain' => array_keys(Settings::options('lowestCeil', null, $settings)),
        )));

        $validation->setLabels(array(
            'defaultClass' => __('Default class'),
            'enableQos' => __('Enable qos'),
            'highestRate' => __('Highest rate'),
            'highestCeil' => __('Highest ceil'),
            'highRate' => __('High rate'),
            'highCeil' => __('High ceil'),
            'mediumRate' => __('Medium rate'),
            'mediumCeil' => __('Medium ceil'),
            'lowRate' => __('Low rate'),
            'lowCeil' => __('Low ceil'),
            'lowestRate' => __('Lowest rate'),
            'lowestCeil' => __('Lowest ceil'),
        ));

        return Settings::updateSettings($settings, $validation);
    }

    /**
     * Umpdate settings method - validate and update settings
     *
     * @package     las
     * @version     1.0
     */
    public static function updateSettings($settings, $validation)
    {
        $crypt = \Phalcon\DI::getDefault()->getShared('crypt');

        foreach ($settings as $setting) {
            // If checkbox is unchecked index not exist
            if ($setting->type == Settings::CHECK && !isset($_POST[$setting->name])) {
                $_POST[$setting->name] = 0;
            }
            // Check if value was changed
            if (isset($_POST[$setting->name]) && $_POST[$setting->name] != $setting->value) {
                // Validate the new value
                $messages = $validation->validate($_POST);

                if (count($messages)) {
                    return $validation->getMessages();
                } else {
                    // Encrypt password field
                    if ($setting->type == Settings::PASSWORD) {
                        $_POST[$setting->name] = $crypt->encryptBase64($_POST[$setting->name]);
                    }
                    $setting->value = $_POST[$setting->name];

                    if ($setting->update() === true) {
                        continue;
                    } else {
                        \Las\Bootstrap::log($setting->getMessages());
                        return $setting->getMessages();
                    }
                }
            }
        }
        return TRUE;
    }

}
