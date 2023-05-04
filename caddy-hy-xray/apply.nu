#!/usr/bin/env nu

let config = (
    open config.yaml
    | insert CERT_DIR_NAME ($in.CURRENT_DOMAIN | str replace '^\*\.' 'wildcard_.')
    | transpose key value)

ls *.template
| get name
| each { |template_file_name| 
    let template_file = (open --raw $template_file_name)
    let final_file_name = ($template_file_name | str replace '.template$' '')
    let final_file = (
        $config 
        | reduce --fold $template_file { |it, acc| 
            $acc | str replace -a $it.key $it.value
        })
    $final_file | save -f $final_file_name
}

echo "Application succeeded."
