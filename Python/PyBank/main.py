'''
Scipt used to perform analysis ober csv file used
to sotre raw bank information

Author: Juan Pablo Castellanos Flores

'''

#General imports
import os
import csv
import collections

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


def log_results(total_monts,
                total_profit,
                average_change,
                great_incr_name,
                great_incr,
                great_dec_name,
                great_dec,
                log_path):
    '''
    Function used to print the analysis of the financial
    information stored in the csv file
    Args:
        total_monts (int):      Total number of months
        average_change (float): Average change month by month
        great_incr_name (str):  Name fo the month that registered
                                the greates increase
        great_incr (int):       Greatest increase value
        great_dec_name (str):   Name fo the month that registered
                                the greates decrease
        great_dec (int):        Greatest decrease value
        log_path (str):         Path for the file used to store the log

    Returns:
        None
    '''
    #Open the file    
    hldr = open(log_path,'w')
    #Write the data
    log("\nFinantial Analysis",hldr)
    log("-"*30,hldr)
    log(f"Total Months : {total_monts}",hldr)
    log(f"Total: {total_profit}",hldr)
    log(f"Average Change : ${round(average_change,2)}",hldr)
    log(f"Greatest Increase in Profits: {great_incr_name} $({great_incr})",hldr)
    log(f"Greatest Decrease in Profits: {great_dec_name} $({great_dec})\n",hldr)
    #Close the file
    hldr.close()


#Get the file path for the CSV file
__thisdir__ = os.path.dirname(os.path.abspath(__file__))
__csv_path__ = os.path.join(__thisdir__,"Resources","budget_data.csv")
#Get the file path for the log
__log_path__ = os.path.join(__thisdir__,"financial_analysis.log")

#Constants for indexing rows
ColumnIndex = collections.namedtuple('ColumnIndex',['date','profit'])
budget_data = ColumnIndex(0,1)

#Variable used for initilization
init_flag = False
previos_profit = 0
greates_increase = {budget_data.date:"",budget_data.profit:0}
greates_decrease = {budget_data.date:"",budget_data.profit:0}
total_val = 0
delata_avg = 0

#Open the file for anaylys
with open(__csv_path__, newline='') as csvfile:
    # CSV reader specifies delimiter and variable that holds contents
    csvreader = csv.reader(csvfile, delimiter=',')
    # Skip the header
    header = next(csvreader)
    # Read each row of data after the header and process the information
    for row in csvreader:
        #Update total
        total_val = total_val + int(row[budget_data.profit])
        #Update the deltas
        if  init_flag:
            current_profit = int(row[budget_data.profit])
            delta = current_profit - previos_profit
            delata_avg = delata_avg + delta
            #Evaluate greates profit
            if delta > greates_increase[budget_data.profit]:
                greates_increase[budget_data.date] = row[budget_data.date]
                greates_increase[budget_data.profit] = delta
            #Evaluate greatest decrease
            if delta < greates_decrease[budget_data.profit]:
                greates_decrease[budget_data.date] = row[budget_data.date]
                greates_decrease[budget_data.profit] = delta
            #Update the profit for the next iteration
            previos_profit = int(row[budget_data.profit])
        else:
            #update the gratest  increase and decrease in case
            #csv file has only 1 row
            greates_increase[budget_data.date] = row[budget_data.date]
            greates_increase[budget_data.profit] = int(row[budget_data.profit])
            greates_decrease[budget_data.date] = row[budget_data.date]
            greates_decrease[budget_data.profit] = int(row[budget_data.profit])
            #Update the previos profit for net calculation
            previos_profit = int(row[budget_data.profit])
            #Set the flag for next row update
            init_flag = True

#Calculate the avergae if value is negative then we have 1 row then delata_avg
#will get the entire change
if csvreader.line_num-2 > 0:
    delata_avg = delata_avg/(csvreader.line_num-2)

#Print the results
log_results(csvreader.line_num-1,
            total_val,
            delata_avg,
            greates_increase[budget_data.date],
            greates_increase[budget_data.profit],
            greates_decrease[budget_data.date],
            greates_decrease[budget_data.profit],
            __log_path__)



