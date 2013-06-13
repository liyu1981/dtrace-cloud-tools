#!/usr/sbin/dtrace -s

#pragma D option dynvarsize=8m

erlang*:::bif-entry
{
	ts[copyinstr(arg0)] = timestamp;
}

erlang*:::bif-return
/(this->ts = ts[copyinstr(arg0)]) > 0/
{
	@[copyinstr(arg1), "ns"] = quantize(timestamp - this->ts);
	ts[copyinstr(arg0)] = 0;
}

tick-1s
{
	printa(@); trunc(@);
}
