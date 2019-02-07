<?php
// Redirect to the Rails version of the page (without .php)
header("Location: /riamco/render?eadid=" .  $_REQUEST['eadid'] . "&view=" . $_REQUEST['view']);
?>