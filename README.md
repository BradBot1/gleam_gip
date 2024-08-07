# gip

[![Package Version](https://img.shields.io/hexpm/v/gip)](https://hex.pm/packages/gip)
[![Hex Docs](https://img.shields.io/badge/hex-docs-ffaff3)](https://hexdocs.pm/gip/)

```sh
gleam add gip
```

```gleam
import gleam/bool
import gleam/io
import gip

pub fn main() {
  io.debug(gip.self()) // Ok(#(x,x,x,x)) | Your current IP
  let ip = "192.0.0.1"
  io.debug("Is IP " <> bool.to_string(gip.is_ip(ip))) // Is IP True | If the provided IP is valid
  io.debug("Is V4 " <> bool.to_string(gip.is_v4(ip))) // Is V4 True | If the provided IP is a valid IPV4
  io.debug("Is V6 " <> bool.to_string(gip.is_v6(ip))) // Is V6 True | If the provided IP is a valid IPV6
  case parse(ip) {
    Ok(parsed) -> {
      io.debug("Can be parsed")
      io.debug(parsed) // #(192,0,0,1) | The IP as a 4xInt tuple
      case stringify(parsed) {
        Ok(stringy) -> io.debug("Can convert into String " <> stringy) // Can convert into String 192.0.0.1 | The IP back as a String
        Error(_) -> panic as "Cannot stringify IP!"
      }
    }
    Error(_) -> panic as "Cannot parse IP!"
  }
}
```

Further documentation can be found at <https://hexdocs.pm/gip>.

## Thanks

- [node-ip](https://github.com/indutny/node-ip) for IP methods on node