--TEST--
TODO: Add tests for your functions
--SKIPIF--
<?php if (!extension_loaded("skeleton")) print "skip"; ?>
--FILE--
<?php
var_dump(skeleton_nop("Hello World"));

?>
--EXPECT--
string(11) "Hello World"

