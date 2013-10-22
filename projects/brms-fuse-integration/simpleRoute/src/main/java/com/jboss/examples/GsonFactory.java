package com.jboss.examples;

import com.google.gson.Gson;
import com.google.gson.GsonBuilder;

/**
 * @author Heiko.Braun <heiko.braun@jboss.com>
 */
public class GsonFactory
{
   public static Gson createInstance()
   {
      Gson gson = new GsonBuilder()
        .setDateFormat("yyyy-MM-dd HH:mm:ss")
        .registerTypeAdapter(java.sql.Timestamp.class, new SQLDateTypeAdapter())
        .create();
      return gson;
   }
}