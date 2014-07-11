{# Admin's Home View | las | 1.0 #}
<h3>{{ __('Admin panel') }}</h3><hr />
<div class="row">
    <div class="col-lg-6">
        <div class="panel panel-default">
            <div class="panel-heading">{{ __('Info') }}</div>
            <div class="form-horizontal" role="form">
                <div class="form-group">
                    <label class="col-sm-4 control-label">{{ __('System') }}:</label>
                    <div class="col-sm-8">
                        <p class="form-control-static">{{ php_uname('s') }} {{ php_uname('r') }} ({{ constant('PHP_OS') }})</p>
                    </div>
                </div>
                <div class="form-group">
                    <label class="col-sm-4 control-label">{{ __('Hostname') }}:</label>
                    <div class="col-sm-8">
                        <p class="form-control-static">{{ info__hostname() }}</p>
                    </div>
                </div>
                {% set release = info__release() %}
                {% if release %}
                    <div class="form-group">
                    <label class="col-sm-4 control-label">{{ __('Distro') }}:</label>
                    <div class="col-sm-8">
                        {% set name = release['NAME']|isset %}
                        <p class="form-control-static">{{ image('img/os/' ~ (name ? name : 'unknown') ~ '.png', 'title': name) }} {{ release['NAME']|isset }} {{ release['VERSION']|isset }}</p>
                    </div>
                </div>
                {% endif %}
                <div class="form-group">
                    <label class="col-sm-4 control-label">{{ __('Web server') }}:</label>
                    <div class="col-sm-8">
                        <p class="form-control-static">{{ request.getServer('SERVER_SOFTWARE') }}</p>
                    </div>
                </div>
                <div class="form-group">
                    <label class="col-sm-4 control-label">{{ __('PHP') }}:</label>
                    <div class="col-sm-8">
                        <p class="form-control-static">{{ phpversion() }}</p>
                    </div>
                </div>
                <div class="form-group">
                    <label class="col-sm-4 control-label">{{ __('Phalcon') }}:</label>
                    <div class="col-sm-8">
                        <p class="form-control-static" title="{{ phalcon_version__getId() }}">{{ version() }}</p>
                    </div>
                </div>
                <div class="form-group">
                    <label class="col-sm-4 control-label">{{ __('Las') }}:</label>
                    <div class="col-sm-8">
                        <p class="form-control-static" title="{{ las__versionId() }}">{{ las__version() }}</p>
                    </div>
                </div>
                <div class="form-group">
                    <label class="col-sm-4 control-label">{{ __('Uptime') }}:</label>
                    <div class="col-sm-8">
                        <p class="form-control-static refresh" id="uptime">{{ info__uptime() }}</p>
                    </div>
                </div>
                <div class="form-group">
                    <label class="col-sm-4 control-label">{{ __('Server time') }}:</label>
                    <div class="col-sm-8">
                        <p class="form-control-static refresh" id="time">{{ date('Y-m-d H:i:s') }}</p>
                    </div>
                </div>
                <div class="form-group">
                    <label class="col-sm-4 control-label">{{ __('Load Averages') }}:</label>
                    <div class="col-sm-8">
                        <p class="form-control-static refresh" id="loadavg">{{ info__loadavg() }}</p>
                    </div>
                </div>
            </div>
        </div>
    </div>
    <div class="col-lg-6">
        <div class="panel panel-default">
            <div class="panel-heading">{{ __('Clients') }}</div>
            <div class="panel-body form-horizontal">
                {% set status = clients__UNACTIVE() %}
                <div class="form-group {{ clients__status(status, 'color') }}">
                    <label class="col-sm-4 control-label">{{ clients__status(status) }}:</label>
                    <div class="col-sm-8">
                        <p class="form-control-static">{{ linkTo(['admin/clients?status=' ~ status, count(clients.filter(las__filter('status', '==', status))), 'class': clients__status(status, 'color')]) }}</p>
                    </div>
                </div>
                {% set status = clients__ACTIVE() %}
                <div class="form-group {{ clients__status(status, 'color') }}">
                    <label class="col-sm-4 control-label">{{ clients__status(status) }}:</label>
                    <div class="col-sm-8">
                        <p class="form-control-static">{{ linkTo(['admin/clients?status=' ~ status, count(clients.filter(las__filter('status', '==', status))), 'class': clients__status(status, 'color')]) }}</p>
                    </div>
                </div>
                {% set status = clients__INDEBTED() %}
                <div class="form-group {{ clients__status(status, 'color') }}">
                    <label class="col-sm-4 control-label">{{ clients__status(status) }}:</label>
                    <div class="col-sm-8">
                        <p class="form-control-static">{{ linkTo(['admin/clients?status=' ~ status, count(clients.filter(las__filter('status', '==', status))), 'class': clients__status(status, 'color')]) }}</p>
                    </div>
                </div>
                {% set status = clients__DISCONNECTED() %}
                <div class="form-group {{ clients__status(status, 'color') }}">
                    <label class="col-sm-4 control-label">{{ clients__status(status) }}:</label>
                    <div class="col-sm-8">
                        <p class="form-control-static">{{ linkTo(['admin/clients?status=' ~ status, count(clients.filter(las__filter('status', '==', status))), 'class': clients__status(status, 'color')]) }}</p>
                    </div>
                </div>
            </div>
        </div>
        <div class="panel panel-default">
            <div class="panel-heading">{{ __('Devices') }}</div>
            <div class="panel-body form-horizontal">
                {% set status = devices__UNACTIVE() %}
                <div class="form-group {{ devices__status(status, 'color') }}">
                    <label class="col-sm-4 control-label">{{ devices__status(status) }}:</label>
                    <div class="col-sm-8">
                        <p class="form-control-static">{{ count(devices.filter(las__filter('status', '==', status))) }}</p>
                    </div>
                </div>
                {% set status = devices__ACTIVE() %}
                <div class="form-group {{ devices__status(status, 'color') }}">
                    <label class="col-sm-4 control-label">{{ devices__status(status) }}:</label>
                    <div class="col-sm-8">
                        <p class="form-control-static">{{ count(devices.filter(las__filter('status', '==', status))) }}</p>
                    </div>
                </div>
            </div>            
        </div>
    </div>
</div>