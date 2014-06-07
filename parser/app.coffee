_ = require 'underscore'
async = require 'async'
mongoose = require 'mongoose'
csv = require 'csv'
fs = require 'fs'
stripBom = require('strip-bom');

utils = {}

utils.csv_to_json = (data) ->
  is_head = true;
  heads = []
  new_data = {}

  _.each data, (row, i) ->
    if(is_head)
      heads = row
      is_head = false
    else
      obj = {}
      main_key = ''
      second_key = ''
      third_key = ''
      _.each row, (value, j) ->
        if j == 1
          main_key = value
        if j == 3
          second_key = value
        if j == 17
          third_key = value
        unless j in [0, 1, 3,  5, 7, 9, 11, 13, 15, 17, 19, 21]
          if heads[j]
            key = heads[j].replace("Descripción de la ", '').replace("Descripción de ", '') 
            obj[key] = value 

      unless main_key of new_data
        new_data[main_key] = {}
        new_data[main_key].decripcion = 
        new_data[main_key][second_key] = []
        #new_data[main_key][second_key] = {}
        #new_data[main_key][second_key][third_key] = [] 
      else
        unless second_key of new_data[main_key]
          new_data[main_key][second_key] = {}
          #new_data[main_key][second_key][third_key] = [] 
          new_data[main_key][second_key] = []
        ###
        else 
          unless third_key of new_data[main_key][second_key]
            new_data[main_key][second_key][third_key] = [] 
        ###
      new_data[main_key][second_key].push obj 
      #new_data[main_key][second_key][third_key].push obj 

  new_data
 
file = './presupuestos2.csv'

data = stripBom fs.readFileSync(file, 'binary')
data = data.split "\n"

new_data = [] 
i = 0
_.each data, (line, i) ->
  dt = []
  _.each line.replace('\r', '').split(','), (value, j) ->
    dt.push value
  new_data.push dt

#console.log new_data[0]
renove_data =  utils.csv_to_json new_data 
console.log renove_data['1']['100']
#fs.writeFileSync('presupuestos.js', JSON.stringify(renove_data), 'utf8')