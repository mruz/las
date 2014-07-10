{# Home View | las | 1.0 #}
{% if client is defined %}
    {% if client.status == clients__DISCONNECTED%}
        <div class="text-center">
            <h4>{{ __('No access') }}</h4><hr />
            <p>{{ image('img/accessdenied.gif', 'alt': __('No access')) }}</p><br />
        </div>
    {% endif %}
{% endif %}
<div class="panel panel-default">
    <div class="panel-heading">{{ __('Info') }}</div>
    <div class="form-horizontal" role="form">
        <div class="form-group">
            <label class="col-sm-4 control-label">{{ __('IP') }}:</label>
            <div class="col-sm-8">
                <p class="form-control-static">{{ ip }}</p>
            </div>
        </div>
        <div class="form-group">
            <label class="col-sm-4 control-label">{{ __('Device') }}:</label>
            <div class="col-sm-8">
                <p class="form-control-static">{{ device is defined ? device.name : __('Not found') }}</p>
            </div>
        </div>
        {% if device is defined %}
            <div class="form-group">
                <label class="col-sm-4 control-label">{{ __('Client') }}:</label>
                <div class="col-sm-8">
                    <p class="form-control-static"><span class="glyphicon glyphicon-flash {{ clients__status(client.status, 'color') }}" title="{{ clients__status(client.status) }}"></span> {{ client.fullName }}</p>
                </div>
            </div>
            <div class="form-group">
                <label class="col-sm-4 control-label">{{ __('Balance') }}:</label>
                <div class="col-sm-8">
                    <p class="form-control-static {{ clients__status(client.status, 'color') }}">{{ balance ? balance ~ las['payments']['currency']|isset : __('None') }}</p>
                </div>
            </div>
        {% endif %}
    </div>
</div>
<br />
<h4 class="text-muted text-center">{{ __('Have a nice day!') }}</h4>