## Overview

EnterpriseEDI is a commercial shipping and logistics software package by
Cargowise and used by logistics companies. Depending on the setup it often has
a SOAP API for clients shipping stuff can check on it's progress. Think
tracking your Fedex package but on a larger scale.

This library provides a nice object based wrapper around the API so you can
pretend the nasty SOAP behind it doesn't exist.

I am in no way personally affiliated with Cargowise or companies that use
EnterpriseEDI. This library was put together for a project that needed access
to specific details of upcoming shipments.

## Installation

    gem install cargowise

## Usage

The API exposes two resources - Order and Shipment. Depending on your logistics
company there may be useful information on either or both.

Cargowise::Order is a purchase order. It's for tracking the status of an order
as it makes it's way from a supplier to you. For these to exist you probably need to
have an arrangement with the logistics company to send them copies when you place
the order.

To find all orders with a certain order number:

    Cargowise::Order.find_by_order_number("123456")

To find all incomplete orders:

    Cargowise::Order.find_incomplete

Cargowise::Shipment represents something being sent to you - like a carton,
palet or truck load. It might be transported via air, sea, road or a combination.

To find shipments by the shipment number (a reference number selected by your logistics
company):

    Cargowise::Shipment.find_by_shipment_number("123456")

To find undelivered shipments:

    Cargowise::Shipment.find_undelivered

To find shipments with activity in the past 14 days (or so):

    Cargowise::Shipment.find_with_recent_activity

All Order and Shipment objects are read only, there are no write capabale
methods exposed via the API. If you see errors, contact your logistics company.

## Finding API Endpoints

Logistics companies that run EnterpriseEDI often don't realise they have an API
so tracking down information on how to set it up can be tricky.

If they have a website for tracking you can start with that URL and then guess
the rest.

For example, OHLs web tracking site is at:

* https://webtracking.ohl.com/

Their two API endpoints are therefore:

* https://webtracking.ohl.com/WebService/ShipmentService.asmx
* https://webtracking.ohl.com/WebService/OrderService.asmx

IJS global has a webtracking site at:

* http://visibility.ijsglobal.com/

Their two API endpoints are:

* http://visibility.ijsglobal.com/Tracker/WebService/SHipmentService.asmx
* http://visibility.ijsglobal.com/Tracker/WebService/OrderService.asmx

## Links

* Cargowise: http://www.cargowise.com/
