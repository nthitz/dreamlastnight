#collection of stuff to make postgres easier

import psycopg2
import os

pgConnectionString = "dbname=" + os.environ['PGNAME'] + " user=" + os.environ['PGUSER'] + " password=" + os.environ['PGPASS']
pg = psycopg2.connect(pgConnectionString)
pgCursor = pg.cursor()
def close():
    pg.commit()
    pgCursor.close()
    pg.close()
def getCursor():
    return pgCursor
savedRelations = {}
def getRelationByKeys(relation, valueKey,cached = True):
    requestRelation(relation, valueKey, cached)
    return savedRelations[relation]['keys']
def getRelationByValues(relation, valueKey,cached = True):
    requestRelation(relation, valueKey, cached)
    return savedRelations[relation]['values']

def getQueryDictionary(q,*arg):
    print arg
    pgCursor.execute(q,arg)
    results = []
    description = pgCursor.description
    for result in pgCursor:
        resultMap = {}
        for i in range(len(result)):
            column = description[i].name
            tuple = result[i]
            resultMap[column] = tuple
        results.append(resultMap)
    return results

def requestRelation(relation, valueKey, cached = True):
    global savedRelations
    # if a cached request is ok
    if cached:
        #and we have a cached request
        if relation in savedRelations:
            #just return the cache
            return
    # else we need to fetch it
    # and update the cache
    print getQueryDictionary
    results = getQueryDictionary('SELECT * FROM ' + relation)
    
    relationByKeys = {}
    relationByValues = {}
    for result in results:
        print result
        id = result[relation + '_id']
        value = result[valueKey]
        relationByKeys[id] = result
        relationByValues[value] = result
    savedRelations[relation] = {}

    savedRelations[relation]['keys'] = relationByKeys
    savedRelations[relation]['values'] = relationByValues


#returns term id and whether or not term is expired
def selectOrInsertTerm(termValue, termType):
    pass