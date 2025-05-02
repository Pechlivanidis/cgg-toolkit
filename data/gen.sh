#!/bin/sh

mkdir output_folder

awk '/>/{printf("+Example-01-%006d ", i++)}1'  example.fasta > output_folder/Example.faa; 
sed -i 's/>//g' output_folder/Example.faa; 
sed -i 's/+/>/g' output_folder/Example.faa; 
