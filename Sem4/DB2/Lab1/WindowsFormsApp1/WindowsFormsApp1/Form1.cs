using System;
using System.Collections.Generic;
using System.ComponentModel;
using System.Data;
using System.Drawing;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using System.Windows.Forms;
using System.Data.SqlClient;
using System.Configuration;
using System.Collections.Specialized;
using System.IO;
using System.Xml;

namespace WindowsFormsApp1
{
    public partial class Form1 : Form
    {

        SqlConnection conn;
        SqlDataAdapter daOne, daMany;
        DataSet ds;
        SqlCommandBuilder cb;
        BindingSource bsOne, bsMany;
        String one, many, query1, query2, keyname, columnFK;

        private void UpdateMovies_Click(object sender, EventArgs e)
        {
            daMany.Update(ds, many);
        }

        public Form1()
        {
            InitializeComponent();
        }

        private void button1_Click(object sender, EventArgs e)
        {

            one = "Categories";
            many ="Movies";
            query1 ="SELECT * FROM Categories";
            query2 ="SELECT * FROM Movies";
            keyname ="FK_Categories_Movies";
            columnFK ="cid";


            string connectionString =
                @"Data Source=MULTIVAC\SQLEXPRESS;Initial Catalog=DBMS_Practical;Integrated Security=True";
            conn = new SqlConnection(connectionString);
            
            ds = new DataSet();

            daOne = new SqlDataAdapter(query1, conn);
            daMany = new SqlDataAdapter(query2, conn);

            cb = new SqlCommandBuilder(daMany);

            daOne.Fill(ds, one);
            daMany.Fill(ds, many);

            DataRelation dr = new DataRelation(keyname, ds.Tables[one].Columns[columnFK], ds.Tables[many].Columns[columnFK]);
            ds.Relations.Add(dr);

            bsOne = new BindingSource();
            bsMany = new BindingSource();

            bsOne.DataSource = ds;
            bsOne.DataMember = one;

            bsMany.DataSource = bsOne;
            bsMany.DataMember = keyname;

            dgvCategories.DataSource = bsOne;
            dgvMovies.DataSource = bsMany;
            
        }
    }
}
