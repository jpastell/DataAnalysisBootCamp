#Imports
import sqlalchemy
import collections
from sqlalchemy.ext.automap import automap_base
from sqlalchemy.orm import Session
from sqlalchemy import create_engine, func, literal
from flask import Flask, jsonify
import datetime as dt
from dateutil.relativedelta import relativedelta
import numpy as np
import pandas as pd



def create_session():


    __SessionData__ = collections.namedtuple('__SessionData__',
                                            ['session',
                                            'Station',
                                            'Measurement'])

    engine = create_engine("sqlite:///Resources/hawaii.sqlite")
    # reflect an existing database into a new model
    Base = automap_base()
    # reflect the tables
    Base.prepare(engine, reflect=True)
    Measurement = Base.classes.measurement
    Station = Base.classes.station
    session = Session(engine)

    SessionData = __SessionData__(session,
                                  Station,
                                  Measurement)


    return SessionData

#################################################
# Flask Setup
#################################################
app = Flask(__name__)


#################################################
# Flask Routes
#################################################


#Instructions are not clear, So I just query for the las 12 monts, if you wan all data you need to pay LOL
@app.route("/api/v1.0/precipitation")
def precipitation():
    """Return the precipitation data as json"""
    my_session =  create_session()

    #Do a quiery to get last date in the data base
    
    sel = [my_session.Measurement.date, my_session.Measurement.prcp]
    
    last_record = my_session.session.query(*sel).\
                    order_by(my_session.Measurement.date.desc()).first()

    sel = [my_session.Station.name, my_session.Measurement.station, my_session.Measurement.date, my_session.Measurement.prcp]


    # Calculate the date 1 year ago from the last data point in the database
    parser_list = last_record[0].split("-")
    last_date = dt.datetime(int(parser_list[0]),int(parser_list[1]),int(parser_list[2]))
    start_date = last_date + relativedelta(months=-12)
    # Perform a query to retrieve the data and precipitation scores
    results = my_session.session.query(*sel).\
                filter(my_session.Measurement.station == my_session.Station.station).\
                filter(my_session.Measurement.date >= start_date.strftime("%Y-%m-%d")).\
                filter(my_session.Measurement.date <= last_date.strftime("%Y-%m-%d")).\
                    order_by(my_session.Measurement.date).all()

    res_json =  [ {"name":row[0], "station":row[1], "date":row[2] , "prcp":row[3] }  for row in  results]
    return jsonify(res_json)

#All stations
@app.route("/api/v1.0/stations")
def satations():
    """Return the precipitation data as json"""
    my_session =  create_session()

    #Do a quiery to get last date in the data base
    
    sel =  [my_session.Station.station,
            my_session.Station.name,
            my_session.Station.latitude,
            my_session.Station.longitude,
            my_session.Station.elevation]
    
    results = my_session.session.query(*sel).all()
    res_json =  [ {"station":row[0], "name":row[1], "lat":row[2] , "long":row[3], "elev":row[4]}  for row in  results]
    return jsonify(res_json)

#Temp for the last 12 months
@app.route("/api/v1.0/tobs")
def tobs():
    """Return the precipitation data as json"""
    my_session =  create_session()

    #Do a quiery to get last date in the data base
    
    sel = [my_session.Measurement.date, my_session.Measurement.prcp]
    
    last_record = my_session.session.query(*sel).\
                    order_by(my_session.Measurement.date.desc()).first()

    sel = [my_session.Station.name, my_session.Measurement.station, my_session.Measurement.date, my_session.Measurement.tobs]


    # Calculate the date 1 year ago from the last data point in the database
    parser_list = last_record[0].split("-")
    last_date = dt.datetime(int(parser_list[0]),int(parser_list[1]),int(parser_list[2]))
    start_date = last_date + relativedelta(months=-12)
    # Perform a query to retrieve the data and precipitation scores
    results = my_session.session.query(*sel).\
                filter(my_session.Measurement.station == my_session.Station.station).\
                filter(my_session.Measurement.date >= start_date.strftime("%Y-%m-%d")).\
                filter(my_session.Measurement.date <= last_date.strftime("%Y-%m-%d")).\
                    order_by(my_session.Measurement.date).all()

    res_json =  [ {"name":row[0], "station":row[1], "date":row[2] , "tobs":row[3] }  for row in  results]
    return jsonify(res_json)



@app.route("/api/v1.0/<start>")
def start(start):
    """Fetch the Justice League character whose real_name matches
       the path variable supplied by the user, or a 404 if not."""

    canonicalized_date = start.replace(" ", "").lower()
    my_session =  create_session()

    #Get the last date
    sel = [my_session.Measurement.date, my_session.Measurement.prcp]
    
    last_record = my_session.session.query(*sel).\
                    order_by(my_session.Measurement.date.desc()).first()

    parser_list = last_record[0].split("-")
    last_date = dt.datetime(int(parser_list[0]),int(parser_list[1]),int(parser_list[2]))

    

    results = my_session.session.query( func.min(my_session.Measurement.tobs),\
                                        func.avg(my_session.Measurement.tobs),\
                                        func.max(my_session.Measurement.tobs)).\
                    filter(my_session.Measurement.date >= start).filter(my_session.Measurement.date <= last_date).all()

    res_json =  [ {"tmin":row[0], "tave":row[1], "tmax":row[2]}  for row in  results]
    return jsonify(res_json)


@app.route("/api/v1.0/<start>/<end>")
def start_end(start,end):
    """Fetch the Justice League character whose real_name matches
       the path variable supplied by the user, or a 404 if not."""

    my_session =  create_session()    

    results = my_session.session.query( func.min(my_session.Measurement.tobs),\
                                        func.avg(my_session.Measurement.tobs),\
                                        func.max(my_session.Measurement.tobs)).\
                    filter(my_session.Measurement.date >= start).filter(my_session.Measurement.date <= end).all()

    res_json =  [ {"tmin":row[0], "tave":row[1], "tmax":row[2]}  for row in  results]
    return jsonify(res_json)


@app.route("/")
def welcome():
    return (
        f"Welcome to the climate API!<br/>"
        f"Available Routes:<br/>"
        f"/api/v1.0/precipitation<br/>"
        f"/api/v1.0/stations<br/>"
        f"/api/v1.0/tobs<br/>"
        f"-----------------<br/>"
        f"Start date:<br/>"
        f"-----------------<br/>"
        f"/api/v1.0/start_date<br/>"
        f"Example:<br/>"
        f"/api/v1.0/2016-08-23<br/>"
        f"-----------------<br/>"
        f"Start and end date:<br/>"
        f"-----------------<br/>"
        f"/api/v1.0/start_date/end_date<br/>"
        f"Example:<br/>"
        f"/api/v1.0/2016-08-23/2016-08-24<br/>"
        f"-----------------<br/>"
    )



if __name__ == "__main__":
    app.run(debug=True)

