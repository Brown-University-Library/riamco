<?php
// Redirect to the Rails version of the page (without .php)
header("Location: /render?eadid=" .  $_REQUEST['eadid'] . "&view=" . $_REQUEST['view']);
?>
