-module(mc_topology_sup).
-behaviour(supervisor).

-export([start_link/3]).

-export([
	init/1
]).

start_link(Seeds, Options, WorkerOptions) ->
	supervisor:start_link({local, ?MODULE}, ?MODULE, [Seeds, Options, WorkerOptions]).

%% @hidden
init(Args) ->
    RestartStrategy = one_for_one,
    MaxRestarts = 100,
    MaxSecondsBetweenRestarts = 600,
    
    SupFlags = {RestartStrategy, MaxRestarts, MaxSecondsBetweenRestarts},

    Restart = permanent,
    Shutdown = 6000,
    Type = worker,

    AChild = {'mc_topology', {'mc_topology', start_link, Args},
        Restart, Shutdown, Type, ['mc_topology']}, 

	{ok, {SupFlags, [AChild]}}.