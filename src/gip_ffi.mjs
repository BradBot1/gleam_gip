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
import ip from './node-ip.js'
import { Ok, Error } from './gleam.mjs'

export function self() {
    return parse(ip.address());
}

export function parse(raw_ip) {
    try {
        return new Ok(ip.toBuffer(raw_ip).toJSON().data);
    } catch {
        return new Error("Invalid IP provided");
    }
}

export function isIP(raw_ip) {
    return isV4(raw_ip) || isV6(raw_ip);
}

export function isV4(raw_ip) {
    return ip.isV4Format(raw_ip);
}

export function isV6(raw_ip) {
    return ip.isV6Format(raw_ip);
}

export function toString(array_ip) {
    let attempt = ip.toString(Buffer.from(array_ip));
    return Array.isArray(attempt) ? new Error("Cannot convert to IP") : new Ok(attempt);
}