<?php

$vars=getopt("",array("site:","fetch:"));
require_once("/var/www/".$vars['site']."/sites/default/settings.php");
exit($databases['default']['default'][$vars['fetch']]);
