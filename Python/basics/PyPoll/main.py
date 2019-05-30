'''
Scipt used to perform analysis ober csv file used
to sotre raw votes for elections

Author: Juan Pablo Castellanos Flores

'''

#General imports
import os
import csv
import collections


#Get the file path for the CSV file
__thisdir__ = os.path.dirname(os.path.abspath(__file__))
__csv_path__ = os.path.join(__thisdir__,"Resources","election_data.csv")
#Get the file path for the log
__log_path__ = os.path.join(__thisdir__,"election_results.log")


#Constants for indexing rows
ColumnIndex = collections.namedtuple('ColumnIndex',['id','county','canidate'])
data = ColumnIndex(0,1,2)


#Dictionary used to store candidates information
results = dict()

#Generic log method
def log(msg,file_hdlr):
    '''
    Function used to print the value to std out
    and a file manages by the file handlers passed
    as parameter.

    Args:
        msg (str):  String to be printed
        file_hdlr(file object): file handler

    Returns:
        None
    '''
    file_hdlr.write(f"{msg}\n")
    print(msg)

#Logging results method
def log_results(total, res_dic, log_path):
    '''
    Function used to print the analysis of the financial
    information stored in the csv file
    Args:
        total (int):            Total number of votes
        res_dic (dictionaty):   Dictionary that stores the number
                                of votes per candidate
        log_path (str):         Path for the file used to store the log
    Returns:
        None
    '''
    max_votes = 0
    winner_key = ""
    #Constant for nuber of symbols for line division
    SimXLine = collections.namedtuple('SimXLine',['number'])
    symbols = SimXLine(30)
    #Open the file    
    hldr = open(log_path,'w')
    #Write the data
    log("\nElection results",hldr)
    log("-"*symbols.number,hldr)
    log(f"Total Votes: {total}",hldr)
    log("-"*symbols.number,hldr)
    #Iterate over the dictionary and print the results
    for candidate, votes in res_dic.items():
        if votes > max_votes:
             max_votes = votes
             winner_key = candidate
        log(f"{candidate} : {round((votes/total)*100,3)}% ({votes})",hldr)
    log("-"*symbols.number,hldr)
    log(f"Winner: {winner_key}",hldr)
    log("-"*symbols.number,hldr)
    #Close the file
    hldr.close()



#Open the file for anaylys
with open(__csv_path__, newline='') as csvfile:
    # CSV reader specifies delimiter and variable that holds contents
    csvreader = csv.reader(csvfile, delimiter=',')
    # Skip the header
    header = next(csvreader)
    # Read each row of data after the header and process the information
    for row in csvreader:
            count = results.get(row[data.canidate])
            if count != None:
                results.update({row[data.canidate]:(count+1)})
            else:
                #Initilize the candidate data
                results.update({row[data.canidate]:1})
#Print the results
log_results(csvreader.line_num-1, results, __log_path__)





