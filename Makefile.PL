use inc::Module::Install;
name 'App-HistHub';
all_from 'lib/App/HistHub.pm';

requires 'Catalyst::Runtime' => '5.70';
requires 'Moose';
requires 'POE::Component::Client::HTTPDeferred';
requires 'HTTP::Request::Common';

test_requires 'Test::More';

use_test_base;
auto_include;
WriteAll;
