using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using CitizenFX.Core;
using static CitizenFX.Core.Native.API;
using System.Data.SQLite;
using System.IO;

namespace SQLite_Wrapper
{
    public class SQLite : BaseScript
    {
        private SQLiteConnection m_dbConnection;
        /*public delegate void ConnectionCallback();
        public delegate void NonQueryCallback(int modifiedrows);
        public delegate void ReaderCallback(List<dynamic> result);*/
        public delegate void Connection(CallbackDelegate cb);
        public delegate void NonQuery(string sql, CallbackDelegate cb);
        public delegate void Reader(string sql, CallbackDelegate cb);
        public SQLite()
        {
            Connection m_openConnection = new Connection(OpenConnection);
            NonQuery m_executeNonQuery = new NonQuery(ExecuteNonQuery);
            Reader m_executeReader = new Reader(ExecuteReader);
            Exports.Add("OpenConnection", m_openConnection);
            Exports.Add("ExecuteNonQuery", m_executeNonQuery);
            Exports.Add("ExecuteReader", m_executeReader);
        }

        private async void OpenConnection(CallbackDelegate cb)
        {
            if (!File.Exists("Nexus.sqlite")) SQLiteConnection.CreateFile("Nexus.sqlite");
            m_dbConnection = new SQLiteConnection("Data Source=Nexus.sqlite;Version=3;");
            m_dbConnection.Open();
            cb();
            await Delay(0);
        }

        private async void ExecuteNonQuery(string sql, CallbackDelegate cb)
        {
            SQLiteCommand m_command = new SQLiteCommand(sql, m_dbConnection);
            int m_modifiedRows = m_command.ExecuteNonQuery();
            cb(m_modifiedRows);
            await Delay(0);
        }
        private async void ExecuteReader(string sql, CallbackDelegate cb)
        {
            SQLiteCommand m_command = new SQLiteCommand(sql, m_dbConnection);
            SQLiteDataReader m_reader = m_command.ExecuteReader();
            List<dynamic> result = new List<dynamic>();
            while (m_reader.Read())
            {
                result.Add(m_reader);
            }
            cb(result);
            await Delay(0);
        }
    }
}
