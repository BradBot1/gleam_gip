//  Copyright 2024 BradBot_1

//  Licensed under the Apache License, Version 2.0 (the "License");
//  you may not use this file except in compliance with the License.
//  You may obtain a copy of the License at

//      http://www.apache.org/licenses/LICENSE-2.0

//  Unless required by applicable law or agreed to in writing, software
//  distributed under the License is distributed on an "AS IS" BASIS,
//  WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
//  See the License for the specific language governing permissions and
//  limitations under the License.
pub type IP {
  /// An IPV4 respresented as a tuple of 4xInt(Int.Int.Int.Int)
  /// All Int's will fall in the bounds 0 <= Int < 255
  V4(#(Int, Int, Int, Int))
  /// An IPV4 respresented as a tuple of 16xInt(Int.Int.Int.Int.Int.Int.Int.Int.Int.Int.Int.Int.Int.Int.Int.Int)
  /// All Int's will fall in the bounds 0 <= Int < 255
  V6(
    #(
      Int,
      Int,
      Int,
      Int,
      Int,
      Int,
      Int,
      Int,
      Int,
      Int,
      Int,
      Int,
      Int,
      Int,
      Int,
      Int,
    ),
  )
}

/// Parses the provided String into an Ip
/// Or povides a message detailing what went wrong
@external(erlang, "gip_ffi", "parse")
@external(javascript, "./gip_ffi.mjs", "parse")
pub fn parse(ip: String) -> Result(IP, String)

/// Checks if the provided Ip is a valid Ip
@external(erlang, "gip_ffi", "is_ip")
@external(javascript, "./gip_ffi.mjs", "isIP")
pub fn is_ip(ip: String) -> Bool

/// Checks if the provided Ip is a valid Ipv4
@external(erlang, "gip_ffi", "is_v4")
@external(javascript, "./gip_ffi.mjs", "isV4")
pub fn is_v4(ip: String) -> Bool

/// Checks if the provided Ip is a valid Ipv6
@external(erlang, "gip_ffi", "is_v6")
@external(javascript, "./gip_ffi.mjs", "isV6")
pub fn is_v6(ip: String) -> Bool

/// Converts the provided Ip into a String
/// Or povides a message detailing what went wrong
@external(erlang, "gip_ffi", "stringify")
@external(javascript, "./gip_ffi.mjs", "toString")
pub fn stringify(ip: IP) -> Result(String, String)

/// Returns the Ip of the current machine
/// Or povides a message detailing what went wrong
@external(erlang, "gip_ffi", "self")
@external(javascript, "./gip_ffi.mjs", "self")
pub fn self() -> Result(IP, String)
