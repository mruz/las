{# Home View | las | 1.0 #}
{% if client is defined %}
    {% if client.status == clients__DISCONNECTED() %}
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
            {% if client.status == clients__INDEBTED() %}
                <div class="text-center">
                    <p>{{ linkTo(['client/temporarily/' ~ client.id, __('Turn on the temporary access'), 'class': 'btn btn-primary']) }}</p>
                </div>
            {% endif %}
            {% if las['payments']['paymentHistory'] and client.getPayments() %}
                <table class="table table-striped table-responsive" style="margin-bottom: 0">
                    <thead>
                        <tr>
                            <th>{{ __('Date') }}</th>
                            <th>{{ __('Amount') }}</th>
                            <th class="hidden-xs">{{ __('Description') }}</th>
                        </tr>
                    </thead>
                    <tbody>
                    {% for payment in client.getPayments(['limit': 40, 'order': 'id DESC']) %}
                        <tr>
                            <td><span class="glyphicon glyphicon-flash {{ payments__status(payment.status, 'color') }}" title="{{ payments__status(payment.status) }}"></span> <span class="small">{{ payment.date }}</span></td>
                            <td>{{ payment.amount }}{{ las['payments']['currency']|isset }}</span></td>
                            <td class="hidden-xs">{{ payment.description }}</span></td>
                        </tr>
                    {% endfor %}
                    </tbody>
                </table>
            {% endif %}
        {% endif %}
    </div>
</div>
<br />
<h4 class="text-muted text-center">{{ __('Have a nice day!') }}</h4>