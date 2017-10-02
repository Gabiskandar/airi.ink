'use strict';

export function debug(content?: string, ...optionalParams: string[]) {
    console.log(`DEBUG: ${content}`, optionalParams);
}

export function info(content?: string, ...optionalParams: string[]) {
    console.log(`INFO: ${content}`, optionalParams);
}

export function warn(content?: string, ...optionalParams: string[]) {
    console.log(`WARN: ${content}`, optionalParams);
}

export function error(content?: string, ...optionalParams: string[]) {
    console.log(`ERROR: ${content}`, optionalParams);
}