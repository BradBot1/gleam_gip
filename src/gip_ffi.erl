%   Copyright 2024 BradBot_1

%   Licensed under the Apache License, Version 2.0 (the "License");
%   you may not use this file except in compliance with the License.
%   You may obtain a copy of the License at

%       http://www.apache.org/licenses/LICENSE-2.0

%   Unless required by applicable law or agreed to in writing, software
%   distributed under the License is distributed on an "AS IS" BASIS,
%   WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
%   See the License for the specific language governing permissions and
%   limitations under the License.
-module(gip_ffi).

-export([parse/1]).
-export([is_ip/1]).
-export([is_v4/1]).
-export([is_v6/1]).
-export([stringify/1]).
-export([self/0]).

parse(RawIp) ->
    case inet:parse_address(erlang:binary_to_list(RawIp)) of
        {ok, Address} -> {ok, unpack(Address)};
        {error, _} -> {error, <<"Invalid IP provided">>}
    end.

unpack(Ip) ->
    if
        erlang:tuple_size(Ip) == 8 -> erlang:list_to_tuple(convert_16bit_list_to_8bit_list(erlang:tuple_to_list(Ip)));
        true -> Ip
    end.

convert_16bit_to_8bit(N) when is_integer(N), N >= 0, N =< 65535 ->
    High8 = (N bsr 8) band 255,
    Low8 = N band 255,
    {High8, Low8}.
convert_16bit_list_to_8bit_list(Nums) when is_list(Nums) ->
    convert_16bit_list_to_8bit_list(Nums, []).
convert_16bit_list_to_8bit_list([], Acc) ->
    lists:reverse(Acc);
convert_16bit_list_to_8bit_list([H | T], Acc) ->
    {High8, Low8} = convert_16bit_to_8bit(H),
    convert_16bit_list_to_8bit_list(T, [Low8, High8 | Acc]).

is_ip(RawIp) ->
    case inet:parse_address(erlang:binary_to_list(RawIp)) of
        {ok, _} -> true;
        {error, _} -> false
    end.

is_v4(RawIp) ->
    case inet:parse_address(erlang:binary_to_list(RawIp)) of
        {ok, Address} -> erlang:tuple_size(Address) == 4;
        {error, _} -> false
    end.

is_v6(RawIp) ->
    case inet:parse_address(erlang:binary_to_list(RawIp)) of
        {ok, Address} -> erlang:tuple_size(Address) == 8;
        {error, _} -> false
    end.

stringify(Ip) -> 
    case inet:ntoa(pack(Ip)) of
        {error, _} -> {error, <<"Cannot convert to IP">>};
        Address -> {ok, erlang:list_to_binary(Address)}
    end.

pack(Ip) ->
    if
        erlang:tuple_size(Ip) == 16 -> erlang:list_to_tuple(convert_8bit_list_to_16bit_list(erlang:tuple_to_list(Ip)));
        true -> Ip
    end.

convert_8bit_to_16bit(High8, Low8) when is_integer(High8), High8 >= 0, High8 =< 255,
                                        is_integer(Low8), Low8 >= 0, Low8 =< 255 ->
    (High8 bsl 8) bor Low8.
convert_8bit_list_to_16bit_list(Bytes) when is_list(Bytes) ->
    convert_8bit_list_to_16bit_list(Bytes, []).
convert_8bit_list_to_16bit_list([], Acc) ->
    lists:reverse(Acc);
convert_8bit_list_to_16bit_list([High8, Low8 | T], Acc) ->
    SixteenBit = convert_8bit_to_16bit(High8, Low8),
    convert_8bit_list_to_16bit_list(T, [SixteenBit | Acc]).

% https://stackoverflow.com/a/32986858
self() ->
    {ok, Addrs} = inet:getifaddrs(),
    {ok, hd([
        Addr || {_, Opts} <- Addrs, {addr, Addr} <- Opts,
        size(Addr) == 4, Addr =/= {127,0,0,1}
    ])}.