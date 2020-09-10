# Author: Stephen Henderson, Student ID: #000815615
try
{
    do{
        # Assign variable of number to be user input
        $number = Read-Host "Select a number 1 through 5
        1. Write Log Files to DailyLog.txt
        2. Write list of PWD to C916contents.txt
        3. Get CPU & Memory Usage
        4. List Running Proceeses in Grid
        5. Exit
        "
        Switch ($number)
        {
            1 
            {
            # Writes files with .log extensions in the present workding directory
            'Writing Log Files to  DailyLog.txt'
            ls *.log . >> DailyLog.txt
            }
            2 
            {
            # Writes the output of the ls command of present working directory to C916contents.txt
            'Writing list of PWD to C916contents.txt'
            ls . | Sort-Object | Format-Table > C916contents.txt
            }
            3
            {
            # Get the CPU & Memory Usage 
            Get-Counter -Counter "\Processor(_Total)\% Processor Time" -SampleInterval 5 -MaxSamples 4
            Get-Counter '\Memory\Available MBytes'
            }
            4 
            {
            # List All running processes sorted by CPU time descending and output to Grid
            Get-Process | Sort CPU -descending | Out-Gridview
            }
            5 
            {
            # Exit script
            'Exiting Script'
            }
        }
    } while($number -notmatch 5)
}
catch [System.OutOfMemoryException]
{
Break
}