package com.example.helloworld;

import android.os.Bundle;
import android.widget.EditText;
import android.widget.TextView;

import android.widget.LinearLayout;
import android.widget.Button;

import android.app.Activity;
import android.view.Menu;
import android.view.View;

import androidx.activity.EdgeToEdge;
import androidx.appcompat.app.AppCompatActivity;
import androidx.core.graphics.Insets;
import androidx.core.view.ViewCompat;
import androidx.core.view.WindowInsetsCompat;

public class MainActivity extends AppCompatActivity {

    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);

        LinearLayout l = new LinearLayout(this);
        Button b = new Button(this);
        b.setText("Tiéfada");
        b.setHeight(200);


        l.setOrientation(LinearLayout.VERTICAL);

        TextView t = new TextView(this);
        TextView s = new TextView(this);

        t.setTextSize(30);
        t.setText("wesssssh");
        s.setTextSize(30);
        s.setText("monreuf");

        b.setOnClickListener(new View.OnClickListener(){
            public void onClick(View v) {
                t.setText("Bonjour !");
            }
        });

        l.addView(t);
        l.addView(s);
        l.addView(b);

        setContentView(l);
        };
    }
