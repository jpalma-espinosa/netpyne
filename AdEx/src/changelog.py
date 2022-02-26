import json
import sys
import pandas as pd
import pygit2 as pg
from datetime import datetime
import os


#reads the github repository commits and places them into a pandas DataFrame

def getCommits(repository):
    repo = pg.Repository(repository)
 
    commits = []
    for commit in repo.walk(repo.head.target, pg.GIT_SORT_TIME):
        #date, hash,message
        commits.append([datetime.utcfromtimestamp(commit.commit_time).strftime('%Y-%m-%d %H:%M:%S'),
                    commit.hex,
                    commit.message])
    return(commits)

def getCommitsFromBranch(repository,branch):
    repo = pg.Repository(repository)
    commits = []
    for commit in repo.branches.get(branch).log():
        message_type = commit.message.split(':')
        if(message_type[0]=='commit'):
            commits.append([datetime.utcfromtimestamp(commit.committer.time).strftime('%Y-%m-%d %H:%M:%S'),
                            str(commit.oid_new)[:7],
                            message_type[1]])
    return(commits)

def make_clickable(val):
    path = "<a href=https://github.com/jpalma-espinosa/netpyne/commit/%s>%s</a>"%(val,val[:8])
    return path

def get_changelog():
    #TODO: update the git path so it is agnostic to the instalation directory
    git_path = "/home/javier/Neuroscience/netpyne/.git"
    branch = 'AdEx-Extension'
    cm = getCommitsFromBranch(git_path,branch) 
    df = pd.DataFrame(cm,columns=['Date','Commit', 'log'])
    #make hash linkeable to the webpage.
    s = df.style.format({"hash": lambda x:make_clickable(x)}).hide_index()
    out = s.set_table_attributes('class="mystyle"').to_html()

    return df