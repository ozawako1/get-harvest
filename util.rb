#!/usr/bin/env ruby
# encoding: utf-8

require "date"
require "csv"
require "json"

CONFIG = "/etc/ozawaapps/webapps.json"

def get_config(webapp, key)
    hash = JSON.parse(File.read(CONFIG))
    return hash[webapp][key]
end

def set_config(webapp, key, value)
    
    hash = JSON.parse(File.read(CONFIG))
    hash[webapp][key] = value
    
    File.open(CONFIG, "w") do |f|
        f.write(JSON.pretty_generate(hash))
    end
end

def flush_to_csv(arr, csvfile, quote = false)
    CSV.open(csvfile, "w", :force_quotes => quote) do |writer|
        arr.each do |line|
            writer << line
        end
    end
end

def get_first_day_of_amoebamonth(yyyy = 0, mm = 0)

    if (yyyy == 0) then
        yyyy = Time.now.year
    end
    if (mm == 0) then
        mm = Time.now.month
    end

    # get the last day of last month
    d = Date.new(yyyy, mm, 1)
    d = d - 1
    
    # check if it was work day
    # if not rewind 1 day
    while (true) do
        if (1 < d.wday && d.wday < 6)
            break
        end
        d = d - 1
    end
    
    return d
end

def get_last_day_of_amoebamonth(yyyy = 0, mm = 0)

    if (yyyy == 0) then
        yyyy = Time.now.year
    end
    if (mm == 0) then
        mm = Time.now.month
    end
    
    if (mm == 12) then
        next_mm = 1
        next_yyyy = yyyy + 1
    else
        next_mm = mm + 1
        next_yyyy = yyyy
    end

    # get the last day of last month
    d = Date.new(next_yyyy, next_mm, 1)
    d = d - 2
    
    # check if it was work day
    # if not rewind 1 day
    while (true) do
        if (1 < d.wday && d.wday < 6)
            break
        end
        d = d - 1
    end
    
    return d    
end


