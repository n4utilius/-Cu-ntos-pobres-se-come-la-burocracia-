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
  res = {}

  _.each data, (row, i) ->
    if(is_head)
      heads = row
      is_head = false
    else
      obj = {}
      main_key = ''
      main_desc = ''

      second_key = ''
      second_desc = ''

      third_key = ''
      third_desc = ''
      _.each row, (value, j) ->

        switch j
          when 1 then main_key = value
          when 2 then main_desc = value
          when 3 then second_key = value
          when 4 then second_desc = value
          when 17 then third_key = value
          
        unless j in [0, 1, 3,  5, 7, 9, 11, 13, 15, 17, 19, 21]
          if heads[j]
            key = heads[j].replace("Descripción de la ", '').replace("Descripción de ", '') 
            obj[key] = value 

      unless main_key of res.data
        res[main_key] =
          descripcion: main_desc
          data: 
            second_key : 
              descripcion: second_desc
              data: []


      else
        unless second_key of res.data[main_key].data
          res.data[main_key].data[second_key] = 

          #res[main_key][second_key][third_key] = [] 
          res[main_key].data =
            second_key : []
        ###
        else 
          unless third_key of res[main_key][second_key]
            res[main_key][second_key][third_key] = [] 
        ###
      res[main_key][second_key].push obj 
      #new_data[main_key][second_key][third_key].push obj 

  res
 
file = './presupuestos.csv'

data = stripBom fs.readFileSync(file, 'binary')
data = data.split "\n"

new_data = [] 
i = 0
_.each data, (line, i) ->
  dt = []
  _.each line.replace('\r', '').split(','), (value, j) ->
    dt.push value
  new_data.push dt

renove_data =  utils.csv_to_json new_data 
console.log renove_data['1']['100']
#fs.writeFileSync('presupuestos.js', JSON.stringify(renove_data), 'utf8')